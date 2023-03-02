// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/elderly/elderly_appointment.dart';
import 'package:seniorcare/elderly/google_fit_set_up.dart';
import 'package:seniorcare/elderly/medication/view_medication_elderly.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/services/firebase_messaging.dart';
import 'package:seniorcare/services/location.dart';
import 'package:seniorcare/services/notification_api.dart';
import 'package:seniorcare/services/server_api.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/start_screen.dart';
import 'package:location/location.dart';
import 'package:seniorcare/widgets/heart_beat.dart';
import 'package:seniorcare/widgets/steps_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // for live tracking of location
  final Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> updateLocation() async {
    await Permission.phone.request();
    await Permission.location.request();
    await Permission.locationAlways.request();

    _locationSubscription = location.onLocationChanged.handleError((onError) {
      _locationSubscription!.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((LocationData currentLocation) async {
      await LocationServices.updateLocation(
          widget.user.email!, currentLocation);
    });

    location.enableBackgroundMode(enable: true);
  }

  // to pull in workmanager
  void setUpSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', widget.user.id!);
  }

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

  void handleMessage(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    List<String> elderlyMealTimings = <String>[];

    Map userDetails = await UserDetails.getUserDetailsWithId(userId!);
    for (String timing in userDetails['meal timings']) {
      DateTime dateTime = DateFormat("hh:mma").parse(timing);
      elderlyMealTimings.add(DateFormat("HH:mm").format(dateTime));
    }

    if (message.data['action'] == 'add') {
      if (message.data['type'] == 'Medication') {
        NotificationServices.createRepeatedNotification(
            userId: widget.user.id!,
            frequency: message.data['frequency'],
            title: Constants.medNotificationTitle,
            body: Constants.medNotificationBody,
            payload: 'Medication',
            mealTimings: elderlyMealTimings);
      } else if (message.data['type'] == 'Appointment') {
        NotificationServices.createScheduledNotification(
            userId: widget.user.id!,
            appointmentId: message.data['appointmentId'],
            title: Constants.apptNotificationTitle,
            body: Constants.apptNotificationBody,
            payload: 'Appointment',
            scheduledDate:
                DateTime.parse(message.data['scheduledReminderTime']),
            caregiver: false);
      }
    } else if (message.data['action'] == 'delete') {
      if (message.data['type'] == 'Medication') {
        NotificationServices.cancelMedicationNotification(
            widget.user.id!, message.data['frequency']);
      } else if (message.data['type'] == 'Appointment') {
        NotificationServices.cancelAppointmentNotifications(
            int.parse(message.data['notificationId']));
      }
    } else if (message.data['action'] == 'update') {
      if (message.data['type'] == 'Medication') {
        NotificationServices.createRepeatedNotification(
            userId: widget.user.id!,
            title: Constants.medNotificationTitle,
            body: Constants.medNotificationBody,
            mealTimings: elderlyMealTimings);
      }
    }
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
  void initState() {
    super.initState();

    listenNotifications();
    registrationToken = FirebaseMessagingService.initializeMessaging();

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      UserDetails.updateMessagingToken(token, widget.user.email!);
    });

    setUpSharedPreferences();
    setUpInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    updateLocation();
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
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.1),
                                        height: size.height * 0.05,
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
                                        padding:
                                            const EdgeInsets.only(right: 35),
                                        height: 40,
                                        width: 120,
                                        color: Colors.transparent,
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
                                            borderRadius: const BorderRadius.all(
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
                                                        textAlign: TextAlign
                                                            .center)))))
                                  ]),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Container(
                                          height: 185,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Color.fromARGB(
                                                  255, 14, 27, 54)),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: const Text(
                                                        "Your Health Status",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(width: 10),
                                                      StepsProgress(
                                                          userId: userId),
                                                      SizedBox(width: 20),
                                                      HeartBeat(userId: userId),
                                                      SizedBox(width: 10)
                                                    ]),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 15))
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
                                                  0, size.height * 0.03, 0, 0)),
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
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            GoogleFitSetUp()));
                                              },
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
                                                        'assets/images/google_fit.png',
                                                        scale: 2.1),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0)),
                                                    const Text("Setup",
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
                                      onTap: () async {
                                        List details = await UserDetails
                                            .getUserDetailsWithEmail(
                                                widget.user.email!);
                                        List<dynamic> caregiver =
                                            details[1]['caregiver'];

                                        List<dynamic> caregiverDetails =
                                            await getCaregiverDetails(
                                                caregiver);

                                        ServerApi.sendSOSPush(caregiverDetails,
                                            details[1]['name']);

                                        _callCaregivers(caregiverDetails);
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

  _callCaregivers(List<dynamic> caregiverDetails) async {
    int i = 0;
    while (i < caregiverDetails.length) {
      await FlutterPhoneDirectCaller.callNumber(
          caregiverDetails[i].emergencyContact);

      i++;
    }
    return;
  }

  getCaregiverDetails(List<dynamic> elderlyCaregiverList) async {
    var caregiverDetails = [];

    if (elderlyCaregiverList.isNotEmpty) {
      for (String element in elderlyCaregiverList) {
        Map details = await UserDetails.getUserDetailsWithId(element);
        Caregiver caregiver = Caregiver(
            email: details['email'],
            name: details['name'],
            emergencyContact: details['emergency contact'],
            registrationToken: details['deviceToken']);
        caregiverDetails.add(caregiver);
      }
    }
    return caregiverDetails;
  }
}
