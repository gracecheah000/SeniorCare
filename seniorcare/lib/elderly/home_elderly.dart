// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:seniorcare/elderly/medication/view_medication_elderly.dart';

import '../widgets/appbar.dart';
import 'elderly_profile.dart';

class HomeElderly extends StatefulWidget {
  const HomeElderly({super.key});

  @override
  State<HomeElderly> createState() => _HomeElderlyState();
}

class _HomeElderlyState extends State<HomeElderly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const SeniorCareAppBar(start: false),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(35, 10, 0, 0),
                    height: 50,
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
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 35, 0),
                    height: 50,
                    width: 120,
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        onTap: () {
                          // TODO: send out message to alert caregiver
                          print("SOS");
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 240, 96, 96),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25))),
                          child: const Center(
                              child: Text(
                            "SOS",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          )),
                        )))
              ],
            ),
            Padding(
                // TODO: change colour and content based on actual health status
                padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromRGBO(203, 246, 202, 1),
                          border: Border.all(
                              color: Color.fromRGBO(203, 246, 202, 1))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: const Text(
                                "Health Status",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                          // TODO: get health status
                          Container()
                        ],
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
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
                                        const ElderlyProfile()));
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
                                          'assets/images/profileButton.png',
                                          scale: 6),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      const Text("Profile",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                    ],
                                  )))),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                                      color: Color.fromRGBO(245, 212, 172, 1),
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
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const ElderlyProfile()));
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
                                      const Text("Health Log",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                    ],
                                  )))),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          ),
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewMedicationElderly()));
                              },
                              child: Ink(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(215, 196, 245, 1),
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
                        ]))
                  ],
                )),
            Padding(
                // TODO: dynamically add reminders
                padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      height: 135,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.transparent,
                          border: Border.all(
                              color: Color.fromRGBO(108, 99, 255, 1))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: const Text(
                                "Reminders",
                                style: TextStyle(
                                    color: Color.fromRGBO(108, 99, 255, 1),
                                    fontWeight: FontWeight.bold),
                              )),
                          Container()
                        ],
                      ),
                    ))),
          ],
        )));
  }
}
