// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/appbar.dart';

class MedicationSettings extends StatefulWidget {
  const MedicationSettings({super.key});

  @override
  State<MedicationSettings> createState() => _MedicationSettingsState();
}

class _MedicationSettingsState extends State<MedicationSettings> {
  @override
  Widget build(BuildContext context) {
    // TODO: add and push to backend - show success message and remove all fields so that they can add another one if necessary
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(35, 30, 0, 0),
                height: 70,
                width: 250,
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
                    "Medication Settings",
                    style: TextStyle(
                        color: Color.fromRGBO(108, 99, 255, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
                )),
          ],
        )));
  }
}
