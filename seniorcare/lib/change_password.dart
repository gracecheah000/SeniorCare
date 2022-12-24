// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'widgets/appbar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.firstLogin});

  final bool firstLogin;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

//todo: create TextEditingController and get values, check and send to backend
class _ChangePasswordState extends State<ChangePassword> {
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
              'CHANGE PASSWORD',
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
                        hintText: 'Current Password',
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(108, 99, 255, 1))),
                    style: const TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1)),
                  )),
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
              const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 20)),
              if (widget.firstLogin == true)
                const Center(
                  child: Text(
                      'You are required to change your password on your first login',
                      style:
                          TextStyle(color: Color.fromARGB(255, 165, 47, 39))),
                )
            ],
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
          FloatingActionButton.extended(
            heroTag: "ChangePassword",
            onPressed: () {},
            label: const Text(
              '    CHANGE PASSWORD    ',
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
