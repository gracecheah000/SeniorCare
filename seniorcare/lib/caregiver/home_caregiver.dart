// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/caregiver/caregiver_appointment.dart';
import 'package:seniorcare/caregiver/location/location_tracking.dart';
import 'package:seniorcare/caregiver/medication/view_medications.dart';
import 'package:seniorcare/caregiver/notes/notepad.dart';
import 'package:seniorcare/services/notification_api.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/start_screen.dart';
import 'package:seniorcare/widgets/appbar.dart';
import '../services/firebase_messaging.dart';
import 'elderly/edit_elderly_details.dart';

class HomeCaregiver extends StatefulWidget {
  const HomeCaregiver({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<HomeCaregiver> createState() => _HomeCaregiverState();
}

class _HomeCaregiverState extends State<HomeCaregiver> {
  Future<String?>? registrationToken;

  @override
  void initState() {
    super.initState();

    listenNotifications();
    registrationToken = FirebaseMessagingService.initializeMessaging();

    // to detect token changes
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      UserDetails.updateMessagingToken(token, widget.userEmail!);
    });
  }

  void onClickedAppointmentNotifications(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              CaregiverAppointment(userEmail: widget.userEmail)));

  void listenNotifications() {
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
            UserDetails.updateMessagingToken(snapshot.data!, widget.userEmail!);
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .where('email', isEqualTo: widget.userEmail)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var userData = snapshot.data.docs[0].data();

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
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 150, 129, 224),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25))),
                                                child: const Center(
                                                    child: Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.center,
                                                )))))
                                  ]),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 40, 50, 0),
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
                                                            EditElderlyProfile(
                                                                caregiverData:
                                                                    userData)));
                                              },
                                              child: Ink(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 15, 0, 15),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          237, 182, 159, 1),
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
                                                    const Text("Your Elderly",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15))
                                                  ])))),
                                          const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 40, 0, 0)),
                                          InkWell(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CaregiverAppointment(
                                                                userEmail: widget
                                                                    .userEmail)));
                                              },
                                              child: Ink(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 15, 0, 15),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          238, 229, 150, 1),
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
                                                  ])))),
                                          const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 40, 0, 0)),
                                          InkWell(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LocationTracking(
                                                                userEmail: widget
                                                                    .userEmail)));
                                              },
                                              child: Ink(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 15, 0, 15),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          203, 246, 202, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Align(
                                                      child: Column(children: <
                                                          Widget>[
                                                    Image.asset(
                                                        'assets/images/map.png',
                                                        scale: 6),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0)),
                                                    const Text("Location",
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
                                                            ViewMedication(
                                                                userEmail: widget
                                                                    .userEmail)));
                                              },
                                              child: Ink(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 15, 0, 15),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          249, 164, 164, 1),
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
                                          const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 40, 0, 0)),
                                          InkWell(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              onTap: () {
                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             const ElderlyProfile()));
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
                                                        'assets/images/ecg-monitor.png',
                                                        scale: 6),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0)),
                                                    const Text("Health Metrics",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15))
                                                  ])))),
                                          const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 40, 0, 0)),
                                          InkWell(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Notepad(
                                                                userEmail: widget
                                                                        .userEmail
                                                                    as String)));
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
                                                        'assets/images/memo.png',
                                                        scale: 6),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0)),
                                                    const Text("Notepad",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15))
                                                  ]))))
                                        ]))
                                  ]))
                            ])));
                  }
                });
          }
        }));
  }
}
