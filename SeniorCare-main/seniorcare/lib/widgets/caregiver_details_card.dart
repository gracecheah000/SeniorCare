import 'package:flutter/material.dart';
import 'package:seniorcare/models/user.dart';

class CaregiverDetailsCard extends StatefulWidget {
  const CaregiverDetailsCard({
    super.key,
    required this.caregiver,
  });

  final Caregiver caregiver;

  @override
  State<CaregiverDetailsCard> createState() => _CaregiverDetailsCardState();
}

class _CaregiverDetailsCardState extends State<CaregiverDetailsCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Card(
        color: const Color.fromARGB(255, 237, 243, 255),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color.fromARGB(255, 176, 200, 233)),
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  top: size.height * 0.02, bottom: size.height * 0.01),
              child: Text(widget.caregiver.name!.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 29, 77, 145)))),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: size.height * 0.01),
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 176, 200, 233),
                      border: Border.all(
                          color: const Color.fromARGB(255, 176, 200, 233)),
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.only(
                    top: size.height * 0.01,
                    left: size.width * 0.02,
                    bottom: size.height * 0.01,
                    right: size.width * 0.02,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Emergency Contact:'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Expanded(
                            child: Text(
                                widget.caregiver.emergencyContact.toString(),
                                style: const TextStyle(fontSize: 15),
                                textAlign: TextAlign.end))
                      ])))
        ])));
  }
}
