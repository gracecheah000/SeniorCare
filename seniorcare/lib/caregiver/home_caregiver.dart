// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:seniorcare/caregiver/caregiver_appointment.dart';
import 'package:seniorcare/caregiver/location/location_tracking.dart';
import 'package:seniorcare/caregiver/medication/view_medications.dart';
import 'package:seniorcare/caregiver/notes/notepad.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'edit_elderly_details.dart';

class HomeCaregiver extends StatefulWidget {
  const HomeCaregiver({super.key});

  @override
  State<HomeCaregiver> createState() => _HomeCaregiverState();
}

class _HomeCaregiverState extends State<HomeCaregiver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const SeniorCareAppBar(start: false),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(35, 30, 0, 0),
                height: 70,
                width: 130,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromRGBO(108, 99, 255, 1),
                          width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: const Center(
                      child: Text(
                    "Home",
                    style: TextStyle(
                        color: Color.fromRGBO(108, 99, 255, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const EditElderlyProfile()));
                              },
                              child: Ink(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(237, 182, 159, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Align(
                                      child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                          'assets/images/profileButton.png',
                                          scale: 6),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      const Text("Edit Profile",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                    ],
                                  )))),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          ),
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CaregiverAppointment()));
                              },
                              child: Ink(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(238, 229, 150, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Align(
                                      child: Column(
                                    children: <Widget>[
                                      Image.asset('assets/images/calendar.png',
                                          scale: 6),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      const Text("Appointment",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                    ],
                                  )))),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          ),
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const LocationTracking()));
                              },
                              child: Ink(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(203, 246, 202, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Align(
                                      child: Column(
                                    children: <Widget>[
                                      Image.asset('assets/images/map.png',
                                          scale: 6),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      const Text("Location",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                    ],
                                  )))),
                        ])),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    ),
                    Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewMedication()));
                              },
                              child: Ink(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(249, 164, 164, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Align(
                                      child: Column(
                                    children: <Widget>[
                                      Image.asset('assets/images/pills.png',
                                          scale: 6),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      const Text("Medication",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                    ],
                                  )))),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          ),
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                // Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const ElderlyProfile()));
                              },
                              child: Ink(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(246, 202, 246, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Align(
                                      child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                          'assets/images/ecg-monitor.png',
                                          scale: 6),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      const Text("Health Metrics",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                    ],
                                  )))),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          ),
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Notepad()));
                              },
                              child: Ink(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(202, 215, 246, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Align(
                                      child: Column(
                                    children: <Widget>[
                                      Image.asset('assets/images/memo.png',
                                          scale: 6),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      const Text("Notepad",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                    ],
                                  )))),
                        ]))
                  ],
                )),
          ],
        )));
  }
}
