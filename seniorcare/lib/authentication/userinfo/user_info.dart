// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/authentication/userinfo/caregiver.dart';
import 'package:seniorcare/authentication/userinfo/elderly.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/user_details.dart';

import '../../caregiver/home_caregiver.dart';
import '../../elderly/home_elderly.dart';
import '../../widgets/appbar.dart';

class FirstTimeUserInfo extends StatefulWidget {
  const FirstTimeUserInfo({super.key, required this.user});

  final User? user;

  @override
  State<FirstTimeUserInfo> createState() => _FirstTimeUserInfoState();
}

class _FirstTimeUserInfoState extends State<FirstTimeUserInfo> {
  String? role = 'Elderly';
  List<DropdownMenuItem<String>> get roleDropdownItems {
    List<DropdownMenuItem<String>> roleMenuItems = [
      const DropdownMenuItem(value: 'Elderly', child: Text('Elderly')),
      const DropdownMenuItem(value: 'Caregiver', child: Text('Caregiver'))
    ];
    return roleMenuItems;
  }

  String? sex = 'Male';

  final name = TextEditingController();
  final emergencyContact = TextEditingController();
  final age = TextEditingController();
  final address = TextEditingController();
  final additionalDetails = TextEditingController();

  List? healthRisks = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const SeniorCareAppBar(start: false),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
              Column(children: <Widget>[
                const Text(
                  'First time login',
                  style: TextStyle(
                      color: Color.fromRGBO(105, 100, 173, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                Divider(
                  height: 20,
                  thickness: 1,
                  indent: size.width * 0.1,
                  endIndent: size.width * 0.1,
                  color: const Color.fromRGBO(108, 99, 255, 1),
                )
              ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0)),
              Column(children: <Widget>[
                Container(
                    width: size.width * 0.86,
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.005, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color.fromRGBO(108, 99, 255, 1))),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: role,
                        style: const TextStyle(
                            color: Color.fromRGBO(108, 99, 255, 1),
                            fontFamily: 'Montserrat',
                            fontSize: 17),
                        items: roleDropdownItems,
                        onChanged: (value) {
                          setState(() {
                            role = value;
                          });
                        },
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Color.fromRGBO(108, 99, 255, 1)))),
                saveOtherDetails(role),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0)),
                FloatingActionButton.extended(
                    heroTag: "Save",
                    onPressed: () {
                      if (role == 'Elderly') {
                        Elderly elderly = Elderly(
                            name: name.text,
                            age: age.text,
                            sex: sex,
                            address: address.text,
                            additionalDetails: additionalDetails.text,
                            healthRisks: healthRisks);
                        UserDetails.saveElderlyDetails(elderly, widget.user);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                HomeElderly(userEmail: widget.user!.email)));
                      } else if (role == 'Caregiver') {
                        Caregiver caregiver = Caregiver(
                            name: name.text,
                            emergencyContact: emergencyContact.text);
                        UserDetails.saveCaregiverDetails(
                            caregiver, widget.user);
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeCaregiver(userEmail: widget.user!.email);
                        }), (r) {
                          return false;
                        });
                      }
                    },
                    label: const Text(
                      '    SAVE    ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    backgroundColor: const Color.fromRGBO(108, 99, 255, 1)),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10))
              ])
            ]))));
  }

  saveOtherDetails(String? role) {
    if (role == 'Elderly') {
      return ElderlyUserInfo(
        name: name,
        age: age,
        address: address,
        additionalDetails: additionalDetails,
        sex: sex,
        notifyParentSex: updateSex,
        notifyParentHealthRisks: updateHealthRisks,
      );
    } else {
      return CaregiverUserInfo(name: name, emergencyContact: emergencyContact);
    }
  }

  updateSex(String? updatedSex) => setState((() {
        sex = updatedSex;
      }));

  updateHealthRisks(List<String>? updatedHealthRisks) => setState((() {
        healthRisks = updatedHealthRisks;
      }));
}