// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../widgets/appbar.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

//todo: create TextEditingController and get values, check and send to backend
class _ForgetPasswordState extends State<ForgetPassword> {
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
              'FORGET PASSWORD',
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
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                          color: Color.fromRGBO(105, 100, 173, 1)))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                          hintText: 'New Password',
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(108, 99, 255, 1))),
                      style: const TextStyle(
                          color: Color.fromRGBO(105, 100, 173, 1)))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                          hintText: 'Confirm New Password',
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(108, 99, 255, 1))),
                      style: const TextStyle(
                          color: Color.fromRGBO(105, 100, 173, 1)))),
              const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
            ],
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
          FloatingActionButton.extended(
            heroTag: "ResetPassword",
            onPressed: () {},
            label: const Text(
              '    RESET    ',
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
