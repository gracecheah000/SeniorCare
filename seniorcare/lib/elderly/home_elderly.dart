// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/elderly/elderly_appointment.dart';
import 'package:seniorcare/elderly/medication/view_medication_elderly.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/services/firebase_messaging.dart';
import 'package:seniorcare/services/notification_api.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/start_screen.dart';

import '../widgets/appbar.dart';
import 'elderly_profile.dart';

class HomeElderly extends StatefulWidget {
  const HomeElderly({super.key, required this.user});

  final Elderly user;

  @override
  State<HomeElderly> createState() => _HomeElderlyState();
}

class _HomeElderlyState extends State<HomeElderly> {
  Future<String?>? registrationToken;
  List<String> elderlyMealTimings = <String>[];

  Future<void> setUpInteractedMessage() async {
    // get any messages which caused the application to open from a terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp
        .listen(handleMessage); // listens to messages when in background

    FirebaseMessaging.onMessage
        .listen(handleMessage); // listens to messages when in foreground
  }

  void handleMessage(RemoteMessage message) {
    print('handling message');
    if (message.data['action'] == 'add') {
      if (message.data['type'] == 'Medication') {
        for (String timing in widget.user.mealTimings!) {
          DateTime dateTime = DateFormat("hh:mma").parse(timing);
          elderlyMealTimings.add(DateFormat("HH:mm").format(dateTime));
        }

        NotificationServices.createRepeatedNotification(
            userId: widget.user.id!,
            frequency: message.data['frequency'],
            title: Constants.medNotificationTitle,
            body: Constants.medNotificationBody,
            payload: 'Medication ${message.data['frequency']}',
            mealTimings: elderlyMealTimings);
      } else if (message.data['type'] == 'Appointment') {
        NotificationServices.createScheduledNotification(
            userId: widget.user.id!,
            appointmentId: message.data['appointmentId'],
            title: Constants.apptNotificationTitle,
            body: Constants.apptNotificationBody,
            payload: 'Appointment',
            scheduledDate: DateTime.parse(message.data['scheduledDateTime']));
      }
    } else if (message.data['action'] == 'delete') {
      if (message.data['type'] == 'Medication') {
        NotificationServices.cancelMedicationNotification(
            widget.user.id!, message.data['frequency']);
      } else if (message.data['type'] == 'Appointment') {
        print('hello');
        NotificationServices.cancelAppointmentNotifications(
            message.data['notificationId'].toInt());
      }
    }
  }

  @override
  void initState() {
    super.initState();

    listenNotifications();
    registrationToken = FirebaseMessagingService.initializeMessaging();

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      UserDetails.updateMessagingToken(token, widget.user.email!);
    });

    setUpInteractedMessage();
  }

  void onClickedMedicationNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewMedicationElderly(
              userId: widget.user.id!, payload: payload)));
  void onClickedAppointmentNotifications(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ElderlyAppointment(userId: widget.user.id!)));

  void listenNotifications() {
    NotificationServices.onMedicationNotifications.stream
        .listen(onClickedMedicationNotification);
    NotificationServices.onAppointmentNotifications.stream
        .listen(onClickedAppointmentNotifications);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: registrationToken,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            UserDetails.updateMessagingToken(
                snapshot.data!, widget.user.email!);
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .where('email', isEqualTo: widget.user.email!)
                    .snapshots(),
                builder: ((BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var userData = snapshot.data.docs[0].data();
                    var userId = snapshot.data.docs[0].id;

                    return Scaffold(
                        backgroundColor: Colors.white,
                        appBar: const SeniorCareAppBar(start: true),
                        body: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(
                                            size.width * 0.1,
                                            size.height * 0.02,
                                            0,
                                            0),
                                        height: size.height * 0.07,
                                        width: size.width * 0.35,
                                        color: Colors.transparent,
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        108, 99, 255, 1),
                                                    width: 2),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(25))),
                                            child: const Center(
                                                child: Text("Home",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            108, 99, 255, 1),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.center)))),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 35, 0),
                                        height: 50,
                                        width: 120,
                                        color: Colors.transparent,
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25)),
                                            onTap: () async {
                                              await Authentication.signOut(
                                                  context: context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const StartScreen(
                                                              title:
                                                                  'SeniorCare')));
                                            },
                                            child: Ink(
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 150, 129, 224),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(25))),
                                                child: const Center(
                                                    child: Text("Logout",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                        textAlign: TextAlign.center)))))
                                  ]),
                              Padding(
                                  // TODO: change colour and content based on actual health status
                                  padding: EdgeInsets.fromLTRB(
                                      15, size.height * 0.01, 15, 5),
                                  child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Container(
                                          height: 140,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Color.fromRGBO(
                                                  203, 246, 202, 1),
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      203, 246, 202, 1))),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: const Text(
                                                      "Health Status",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                // TODO: get health status
                                                Container()
                                              ])))),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      50, size.height * 0.01, 50, 0),
                                  child: Row(children: <Widget>[
                                    Flexible(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          InkWell(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ElderlyProfile(
                                                                elderlyData:
                                                                    userData)));
                                              },
                                              child: Ink(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 15, 0, 15),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          246, 202, 246, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Align(
                                                      child: Column(children: <
                                                          Widget>[
                                                    Image.asset(
                                                        'assets/images/profileButton.png',
                                                        scale: 6),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0)),
                                                    const Text("Profile",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15))
                                                  ])))),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, size.height * 0.03, 0, 0),
                                          ),
                                          InkWell(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ElderlyAppointment(
                                                                userId:
                                                                    userId)));
                                              },
                                              child: Ink(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 15, 0, 15),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          245, 212, 172, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Align(
                                                      child: Column(children: <
                                                          Widget>[
                                                    Image.asset(
                                                        'assets/images/calendar.png',
                                                        scale: 6),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0)),
                                                    const Text("Appointment",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15))
                                                  ]))))
                                        ])),
                                    const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 0)),
                                    Flexible(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          InkWell(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewMedicationElderly(
                                                                userId:
                                                                    userId)));
                                              },
                                              child: Ink(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 15, 0, 15),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 160, 245, 243),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Align(
                                                      child: Column(children: <
                                                          Widget>[
                                                    Image.asset(
                                                        'assets/images/pills.png',
                                                        scale: 6),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0)),
                                                    const Text("Medication",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15))
                                                  ])))),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, size.height * 0.03, 0, 0)),
                                          InkWell(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              onTap: () {},
                                              child: Ink(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 15, 0, 15),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          202, 215, 246, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Align(
                                                      child: Column(children: <
                                                          Widget>[
                                                    Image.asset(
                                                        'assets/images/memo.png',
                                                        scale: 6),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0)),
                                                    const Text("Health Log",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15))
                                                  ]))))
                                        ]))
                                  ])),
                              Container(
                                  padding: EdgeInsets.fromLTRB(size.width * 0.1,
                                      size.height * 0.03, size.width * 0.1, 0),
                                  height: size.height * 0.13,
                                  width: size.width * 1,
                                  color: Colors.transparent,
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25)),
                                      onTap: () {
                                        // TODO: send out message to alert caregiver
                                        print('SOS');
                                      },
                                      child: Ink(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 240, 96, 96),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(25))),
                                          child: const Center(
                                              child: Text("SOS",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                  textAlign:
                                                      TextAlign.center)))))
                            ])));
                  }
                }));
          }
        }));
  }
}
