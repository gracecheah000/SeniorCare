// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seniorcare/models/medication.dart';
import 'package:seniorcare/services/medication.dart';

class MedicationCard extends StatefulWidget {
  final Medication medication;
  final String medicationId;
  final String elderlyId;

  const MedicationCard(
      {super.key,
      required this.medication,
      required this.medicationId,
      required this.elderlyId});

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
        color: Color.fromARGB(255, 217, 226, 240),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: const Color.fromARGB(255, 176, 200, 233)),
            borderRadius: BorderRadius.circular(20)),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(
                  0, size.height * 0.01, size.width * 0.04, size.height * 0.01),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () async {
                          var result =
                              await MedicationServices.deleteMedication(
                                  widget.elderlyId, widget.medicationId);
                          if (result != true) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(result),
                                duration: Duration(seconds: 2)));
                          }
                        },
                        icon: Image.asset('assets/images/bin_blue.png'),
                        iconSize: 55,
                        splashRadius: 20)
                  ])),
          Text(widget.medication.medicationName,
              style: TextStyle(
                  color: Color.fromARGB(255, 29, 77, 145),
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Divider(
              height: size.height * 0.03,
              thickness: 1,
              indent: size.width * 0.1,
              endIndent: size.width * 0.1,
              color: Color.fromARGB(255, 29, 77, 145)),
          Container(
              height: size.height * 0.2,
              width: size.width * 0.4,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.memory(
                  base64Decode(widget.medication.medicationImage))),
          Container(
              padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
              height: size.height * 0.05,
              width: size.width * 0.55,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromARGB(255, 29, 77, 145)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: Center(
                      child: Text(widget.medication.medicationQuantity,
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 77, 145)))))),
          Container(
              padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
              height: size.height * 0.05,
              width: size.width * 0.55,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromARGB(255, 29, 77, 145)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: Center(
                      child: Text(widget.medication.medicationFrequency,
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 77, 145)))))),
          Container(
              padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
              height: size.height * 0.05,
              width: size.width * 0.55,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromARGB(255, 29, 77, 145)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: Center(
                      child: Text(widget.medication.medicationTime,
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 77, 145)))))),
          Container(
              padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
              height: size.height * 0.05,
              width: size.width * 0.55,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromARGB(255, 29, 77, 145)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: Center(
                      child: Text(widget.medication.medicationPrescription,
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 77, 145)))))),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          ),
          (widget.medication.otherDescription == '')
              ? Container()
              : Container(
                  width: size.width * 0.55,
                  height: size.height * 0.1,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromARGB(255, 29, 77, 145)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Center(
                              child: Text(
                                  widget.medication.otherDescription as String,
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 29, 77, 145)))))))
        ]));
  }
}
