// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seniorcare/models/medication.dart';
import 'package:seniorcare/services/medication.dart';
import 'package:seniorcare/services/server_api.dart';

class MedicationCard extends StatefulWidget {
  final Medication medication;
  final String elderlyId;
  final String? registrationToken;

  const MedicationCard(
      {super.key,
      required this.medication,
      required this.elderlyId,
      this.registrationToken});

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
          widget.registrationToken != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, size.height * 0.01, size.width * 0.04, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              _showDialog(context);
                            },
                            icon: Image.asset('assets/images/bin_blue.png'),
                            iconSize: 55,
                            splashRadius: 20)
                      ]))
              : SizedBox(height: size.height * 0.05),
          Text(widget.medication.medicationName,
              style: TextStyle(
                  color: Color.fromARGB(255, 29, 77, 145),
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Divider(
              height: size.height * 0.02,
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
          (widget.medication.otherDescription == '')
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
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
                                      color: Color.fromARGB(
                                          255, 29, 77, 145))))))),
          (widget.medication.startDate == null)
              ? Container()
              : Container(
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
                          child: Text(
                              'Started On: ${widget.medication.startDate!}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 77, 145)))))),
          (widget.medication.endDate == null)
              ? Container()
              : Container(
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
                          child: Text('Ended On: ${widget.medication.endDate!}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 77, 145))))))
        ]));
  }

  _showDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Removing medication"),
                content: Text(
                    "Would you like to delete it completely, or move it to medication history?"),
                actions: [
                  TextButton(
                      child: Text("Delete"),
                      onPressed: () async {
                        var result = await MedicationServices.deleteMedication(
                            widget.elderlyId, widget.medication.medicationId!);
                        if (result != true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result),
                              duration: Duration(seconds: 2)));
                        } else {
                          ServerApi.deleteMedicationPush(
                              widget.medication, widget.registrationToken!);
                          Navigator.pop(context);
                          return;
                        }
                      }),
                  TextButton(
                      child: Text("Completed"),
                      onPressed: () async {
                        var result =
                            await MedicationServices.updateElderlyMedication(
                                widget.elderlyId,
                                widget.medication.medicationId!);

                        if (result != true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result),
                              duration: Duration(seconds: 2)));
                        } else {
                          ServerApi.deleteMedicationPush(
                              widget.medication, widget.registrationToken!);
                          Navigator.of(context).pop();
                          return;
                        }
                      })
                ]));
  }
}
