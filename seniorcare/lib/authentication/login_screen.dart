// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:seniorcare/authentication/forget_password.dart';

import 'change_password.dart';
import '../caregiver/home_caregiver.dart';
import '../elderly/home_elderly.dart';
import '../widgets/appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? role = 'Elderly';
  List<DropdownMenuItem<String>> get roleDropdownItems {
    List<DropdownMenuItem<String>> roleMenuItems = [
      DropdownMenuItem(child: Text('Elderly'), value: 'Elderly'),
      DropdownMenuItem(child: Text('Caregiver'), value: 'Caregiver')
    ];
    return roleMenuItems;
  }

  // TODO: change text fields to forms
  @override
  Widget build(BuildContext context) {
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
              'LOGIN',
              style: TextStyle(
                  color: Color.fromRGBO(105, 100, 173, 1),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 40,
              endIndent: 40,
              color: Color.fromRGBO(108, 99, 255, 1),
            )
          ]),
          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
          Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromRGBO(108, 99, 255, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromRGBO(105, 100, 173, 1))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 255, 104, 99))),
                        hintText: 'Phone Number',
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(108, 99, 255, 1))),
                    style: const TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1))),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromRGBO(108, 99, 255, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromRGBO(105, 100, 173, 1))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 255, 104, 99))),
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(108, 99, 255, 1))),
                    style: const TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1))),
              ),
              Container(
                  width: 290,
                  height: 30,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(108, 99, 255, 1))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ForgetPassword()));
                      },
                      child: const Text('Forget Password'))),
              const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
              Container(
                  width: 310,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border:
                          Border.all(color: Color.fromRGBO(108, 99, 255, 1))),
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
                          color: Color.fromRGBO(108, 99, 255, 1))))
            ],
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
          FloatingActionButton.extended(
            heroTag: "Login",
            onPressed: () {
              if (role == 'null') {
                // todo: add error message
              } else if (role == 'Elderly') {
                // todo: authenticate user
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeElderly()));
              } else if (role == 'Caregiver') {
                // todo: authenticate user and check for first login
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeCaregiver()));
              }
            },
            label: const Text(
              '    LOGIN    ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
          )
        ],
      ))),
    );
  }
}
