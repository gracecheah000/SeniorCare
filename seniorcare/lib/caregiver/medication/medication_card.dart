// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  String medicationName;
  String medicationImage;
  String medicationFrequency;
  String medicationQuantity;
  String medicationTime;
  String medicationPrescription;
  String otherDescription;

  MedicationCard(
      this.medicationName,
      this.medicationImage,
      this.medicationFrequency,
      this.medicationQuantity,
      this.medicationTime,
      this.medicationPrescription,
      this.otherDescription,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color.fromARGB(255, 255, 248, 242),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 240, 208, 182)),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 20, 20),

                // TODO: CRUD function
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      icon: Image.asset('assets/images/edit.png'),
                      iconSize: 60,
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      icon: Image.asset('assets/images/bin.png'),
                      iconSize: 40,
                    ),
                  ],
                )),
            Text(medicationName,
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
                child: Image.asset(medicationImage)),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                height: 55,
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
                        child: Text(medicationQuantity,
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
                        child: Text(medicationFrequency,
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
                        child: Text(medicationTime,
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
                        child: Text(medicationPrescription,
                            style: TextStyle(
                                color: Color.fromARGB(255, 182, 115, 60)))))),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        color: const Color.fromARGB(255, 182, 115, 60)),
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Center(
                            child: Text(otherDescription,
                                style: TextStyle(
                                    color:
                                        Color.fromARGB(255, 182, 115, 60))))))),
          ],
        ));
  }
}
