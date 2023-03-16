// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seniorcare/models/medication.dart';

class ElderlyMedicationCard extends StatefulWidget {
  final Medication medication;
  final String medicationId;
  final String elderlyId;
  final bool payload;

  const ElderlyMedicationCard(
      {required this.medication,
      required this.medicationId,
      required this.elderlyId,
      this.payload = false,
      super.key});

  @override
  State<ElderlyMedicationCard> createState() => _ElderlyMedicationCardState();
}

class _ElderlyMedicationCardState extends State<ElderlyMedicationCard> {
  bool _isComplete = false;

  enableButton(String medicationName) {
    if (!_isComplete) {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          height: 50,
          width: 150,
          color: Colors.transparent,
          child: FloatingActionButton.extended(
              heroTag: "Complete$medicationName",
              backgroundColor: Color.fromARGB(255, 29, 77, 145),
              onPressed: () {
                setState(() {
                  _isComplete = true;
                });
              },
              label: Text("COMPLETE",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  textAlign: TextAlign.center)));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
        color: Color.fromARGB(255, 217, 226, 240),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 217, 226, 240)),
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0, size.height * 0.05, 0, 0)),
          Text(widget.medication.medicationName,
              style: TextStyle(
                  color: Color.fromARGB(255, 29, 77, 145),
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          const Divider(
              height: 30,
              thickness: 2,
              indent: 30,
              endIndent: 30,
              color: Color.fromARGB(255, 29, 77, 145)),
          Container(
              height: size.width * 0.4,
              width: size.width * 0.8,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.memory(
                  base64Decode(widget.medication.medicationImage))),
          Container(
              padding: EdgeInsets.fromLTRB(0, size.height * 0.03, 0, 0),
              height: size.height * 0.07,
              width: size.width * 0.6,
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
                              color: Color.fromARGB(255, 29, 77, 145),
                              fontSize: 18))))),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              height: size.height * 0.07,
              width: size.width * 0.6,
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
                              color: Color.fromARGB(255, 29, 77, 145),
                              fontSize: 18))))),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              height: size.height * 0.07,
              width: size.width * 0.6,
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
                              color: Color.fromARGB(255, 29, 77, 145),
                              fontSize: 18))))),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              height: size.height * 0.07,
              width: size.width * 0.6,
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
                              color: Color.fromARGB(255, 29, 77, 145),
                              fontSize: 18))))),
          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
          (widget.medication.otherDescription == '')
              ? Container()
              : Container(
                  width: size.width * 0.6,
                  height: 45,
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
                                      color: Color.fromARGB(255, 29, 77, 145),
                                      fontSize: 18)))))),
          widget.payload == false
              ? Container()
              : enableButton(widget.medication.medicationName),
          Padding(padding: EdgeInsets.only(bottom: 10))
        ])));
  }
}
