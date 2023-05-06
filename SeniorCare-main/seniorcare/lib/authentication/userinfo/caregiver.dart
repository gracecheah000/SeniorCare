// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/custom_text_field.dart';

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
    var size = MediaQuery.of(context).size;

    return Column(children: <Widget>[
      const Padding(padding: EdgeInsets.only(top: 10)),
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07, vertical: size.height * 0.015),
          child: customTextField(controller: widget.name, hint: 'Name')),
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07, vertical: size.height * 0.015),
          child: customTextField(
              controller: widget.emergencyContact, hint: 'Emergency Contact'))
    ]);
  }
}
