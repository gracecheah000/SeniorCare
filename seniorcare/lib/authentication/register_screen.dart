// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:seniorcare/caregiver/caregiver_details.dart';
import 'package:seniorcare/widgets/appbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<CaregiverDetails> dynamicCaregiverList = [];
  List<String> name = [];
  List<String> phoneNumber = [];

  addCaregiverDetails() {
    if (name.isNotEmpty) {
      name = [];
      phoneNumber = [];
      dynamicCaregiverList = [];
    }
    setState(() {});
    // here, setting maximum number of caregivers: 3
    if (dynamicCaregiverList.length >= 2) {
      return;
    }
    dynamicCaregiverList.add(CaregiverDetails(
      number: dynamicCaregiverList.length + 2,
    ));
  }

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
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          ),
          Column(children: <Widget>[
            const Text(
              'REGISTER',
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
              const Text('Elderly',
                  style: TextStyle(
                      color: Color.fromRGBO(105, 100, 173, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat')),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                          hintText: 'Name',
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(108, 99, 255, 1))),
                      style: const TextStyle(
                          color: Color.fromRGBO(105, 100, 173, 1)))),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                        hintText: 'PIN',
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(108, 99, 255, 1))),
                    style: const TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1))),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
          Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Caregiver 1',
                      style: TextStyle(
                          color: Color.fromRGBO(105, 100, 173, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          addCaregiverDetails();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5),
                            backgroundColor: Colors.white,
                            elevation: 0),
                        child: const Icon(Icons.add_circle_outline_rounded,
                            color: Color.fromRGBO(105, 100, 173, 1)))
                  ]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                      hintText: 'Name',
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(108, 99, 255, 1))),
                  style:
                      const TextStyle(color: Color.fromRGBO(105, 100, 173, 1)),
                  keyboardType: TextInputType.name,
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                        color: Color.fromRGBO(105, 100, 173, 1)),
                    keyboardType: TextInputType.phone,
                  )),
              ListView.builder(
                shrinkWrap: true,
                itemCount: dynamicCaregiverList.length,
                itemBuilder: (context, index) {
                  return dynamicCaregiverList[index];
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
            child: FloatingActionButton.extended(
              heroTag: "register",
              onPressed: () {},
              label: const Text(
                '    REGISTER    ',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
              backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
            ),
          )
        ],
      ))),
    );
  }
}
