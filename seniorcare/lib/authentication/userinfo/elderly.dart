// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/custom_multi_select_widget.dart';

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
  List<DropdownMenuItem<String>> get sexDropDownItems {
    List<DropdownMenuItem<String>> sexMenuItems = [
      const DropdownMenuItem(value: 'Male', child: Text('Male')),
      const DropdownMenuItem(value: 'Female', child: Text('Female'))
    ];
    return sexMenuItems;
  }

  List<String> items = ['Diabetes', 'High Blood Cholesterol'];

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
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              }),
              controller: widget.age,
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
                  hintText: 'Age',
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(108, 99, 255, 1))),
              style: const TextStyle(color: Color.fromRGBO(105, 100, 173, 1))),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Container(
            width: 310,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border:
                    Border.all(color: const Color.fromRGBO(108, 99, 255, 1))),
            child: DropdownButton<String>(
                isExpanded: true,
                value: widget.sex,
                style: const TextStyle(
                    color: Color.fromRGBO(108, 99, 255, 1),
                    fontFamily: 'Montserrat',
                    fontSize: 17),
                items: sexDropDownItems,
                onChanged: (value) {
                  setState(() {
                    widget.notifyParentSex(value);
                  });
                },
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down,
                    color: Color.fromRGBO(108, 99, 255, 1)))),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextFormField(
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              }),
              controller: widget.address,
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
                  hintText: 'Address',
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(108, 99, 255, 1))),
              style: const TextStyle(color: Color.fromRGBO(105, 100, 173, 1))),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        MultiSelect(
          items: items,
          updateHealthRisks: updateParentHealthRisks,
          healthRisks: [],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextFormField(
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              }),
              controller: widget.additionalDetails,
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
                  hintText: 'Additional Details',
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(108, 99, 255, 1))),
              style: const TextStyle(color: Color.fromRGBO(105, 100, 173, 1))),
        ),
      ],
    );
  }

  updateParentHealthRisks(List<String> updatedHealthRisks) {
    widget.notifyParentHealthRisks(updatedHealthRisks);
  }
}
