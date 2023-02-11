// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/widgets/custom_multi_select_widget.dart';
import 'package:seniorcare/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class ElderlyUserInfo extends StatefulWidget {
  ElderlyUserInfo(
      {super.key,
      required this.name,
      required this.age,
      required this.address,
      required this.additionalDetails,
      required this.sex,
      required this.notifyParentSex,
      required this.notifyParentHealthRisks});

  final TextEditingController name;
  final TextEditingController age;
  final TextEditingController address;
  final TextEditingController additionalDetails;
  final Function notifyParentSex;
  final Function notifyParentHealthRisks;
  String? sex;

  @override
  State<ElderlyUserInfo> createState() => _ElderlyUserInfoState();
}

class _ElderlyUserInfoState extends State<ElderlyUserInfo> {
  List<DropdownMenuItem<String>> sexMenuItems = Constants.sexMenuItems;

  List<String> items = ['Diabetes', 'High Blood Cholesterol'];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(children: <Widget>[
      Padding(padding: EdgeInsets.only(top: size.height * 0.01)),
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07, vertical: size.height * 0.015),
          child: customTextField(controller: widget.name, hint: 'Name')),
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07, vertical: size.height * 0.01),
          child: customTextField(controller: widget.age, hint: 'Age')),
      Padding(padding: EdgeInsets.only(top: size.height * 0.015)),
      Container(
          width: size.width * 0.86,
          padding: EdgeInsets.symmetric(
              vertical: size.height * 0.005, horizontal: size.width * 0.03),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color.fromRGBO(108, 99, 255, 1))),
          child: DropdownButton<String>(
              isExpanded: true,
              value: widget.sex,
              style: const TextStyle(
                  color: Color.fromRGBO(108, 99, 255, 1),
                  fontFamily: 'Montserrat',
                  fontSize: 16),
              items: sexMenuItems,
              onChanged: (value) {
                setState(() {
                  widget.notifyParentSex(value);
                });
              },
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down,
                  color: Color.fromRGBO(108, 99, 255, 1)))),
      Padding(padding: EdgeInsets.only(top: size.height * 0.01)),
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07, vertical: size.height * 0.015),
          child: customTextField(controller: widget.address, hint: 'Address')),
      Padding(padding: EdgeInsets.only(top: size.height * 0.01)),
      MultiSelect(
          items: items,
          updateHealthRisks: updateParentHealthRisks,
          healthRisks: []),
      Padding(padding: EdgeInsets.only(top: size.height * 0.01)),
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07, vertical: size.height * 0.015),
          child: customTextField(
              controller: widget.additionalDetails, hint: 'Additional Details'))
    ]);
  }

  updateParentHealthRisks(List<String> updatedHealthRisks) {
    widget.notifyParentHealthRisks(updatedHealthRisks);
  }
}
