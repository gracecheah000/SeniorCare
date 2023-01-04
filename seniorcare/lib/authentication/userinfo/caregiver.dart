// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CaregiverUserInfo extends StatefulWidget {
  const CaregiverUserInfo(
      {super.key, required this.name, required this.emergencyContact});

  final TextEditingController name;
  final TextEditingController emergencyContact;

  @override
  State<CaregiverUserInfo> createState() => _CaregiverUserInfoState();
}

class _CaregiverUserInfoState extends State<CaregiverUserInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(top: 10)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextFormField(
              controller: widget.name,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              }),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          width: 1, color: Color.fromRGBO(108, 99, 255, 1))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromRGBO(105, 100, 173, 1))),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          width: 1, color: Color.fromARGB(255, 255, 104, 99))),
                  hintText: 'Name',
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(108, 99, 255, 1))),
              style: const TextStyle(color: Color.fromRGBO(105, 100, 173, 1))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextFormField(
              controller: widget.emergencyContact,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              }),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          width: 1, color: Color.fromRGBO(108, 99, 255, 1))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromRGBO(105, 100, 173, 1))),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          width: 1, color: Color.fromARGB(255, 255, 104, 99))),
                  hintText: 'Emergency Contact',
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(108, 99, 255, 1))),
              style: const TextStyle(color: Color.fromRGBO(105, 100, 173, 1))),
        ),
      ],
    );
  }
}
