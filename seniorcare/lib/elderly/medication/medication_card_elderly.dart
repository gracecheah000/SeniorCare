// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class ElderlyMedicationCard extends StatefulWidget {
  String medicationName;
  String medicationImage;
  String medicationFrequency;
  String medicationQuantity;
  String medicationTime;
  String medicationPrescription;
  String otherDescription;

  ElderlyMedicationCard(
      this.medicationName,
      this.medicationImage,
      this.medicationFrequency,
      this.medicationQuantity,
      this.medicationTime,
      this.medicationPrescription,
      this.otherDescription,
      {super.key});

  @override
  State<ElderlyMedicationCard> createState() => _ElderlyMedicationCardState();
}

class _ElderlyMedicationCardState extends State<ElderlyMedicationCard> {
  bool _isComplete = false;

  enableButton(String medicationName) {
    if (!_isComplete) {
      return Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          height: 80,
          width: 150,
          color: Colors.transparent,
          child: FloatingActionButton.extended(
            heroTag: "Complete" + medicationName,
            backgroundColor: Color.fromARGB(255, 182, 115, 60),
            onPressed: () {
              setState(() {
                _isComplete = true;
              });
            },
            label: Text(
              "COMPLETE",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color.fromARGB(255, 255, 248, 242),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 240, 208, 182)),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
            Text(widget.medicationName,
                style: TextStyle(
                    color: Color.fromARGB(255, 182, 115, 60),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const Divider(
              height: 30,
              thickness: 1,
              indent: 30,
              endIndent: 30,
              color: Color.fromARGB(255, 182, 115, 60),
            ),
            Container(
                height: 100,
                width: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Image.asset(widget.medicationImage)),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                height: 65,
                width: 200,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromARGB(255, 182, 115, 60)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: Center(
                        child: Text(widget.medicationQuantity,
                            style: TextStyle(
                                color: Color.fromARGB(255, 182, 115, 60)))))),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                height: 45,
                width: 200,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromARGB(255, 182, 115, 60)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: Center(
                        child: Text(widget.medicationFrequency,
                            style: TextStyle(
                                color: Color.fromARGB(255, 182, 115, 60)))))),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                height: 45,
                width: 200,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromARGB(255, 182, 115, 60)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: Center(
                        child: Text(widget.medicationTime,
                            style: TextStyle(
                                color: Color.fromARGB(255, 182, 115, 60)))))),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                height: 45,
                width: 200,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromARGB(255, 182, 115, 60)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: Center(
                        child: Text(widget.medicationPrescription,
                            style: TextStyle(
                                color: Color.fromARGB(255, 182, 115, 60)))))),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            Container(
                width: 200,
                height: 50,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromARGB(255, 182, 115, 60)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: Center(
                        child: Text(widget.otherDescription,
                            style: TextStyle(
                                color: Color.fromARGB(255, 182, 115, 60)))))),
            enableButton(widget.medicationName)
          ],
        ));
  }
}
