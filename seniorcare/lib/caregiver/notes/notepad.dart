// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:seniorcare/caregiver/notes/notes_edit.dart';
import 'package:seniorcare/widgets/appbar.dart';

class Notepad extends StatefulWidget {
  const Notepad({super.key});

  @override
  State<Notepad> createState() => _NotepadState();
}

class _NotepadState extends State<Notepad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  height: 50,
                  width: 130,
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromRGBO(108, 99, 255, 1),
                            width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: const Center(
                        child: Text(
                      "Notepad",
                      style: TextStyle(
                          color: Color.fromRGBO(108, 99, 255, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    )),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(108, 99, 255, 1))),
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[],
                      )))),
            ]),
        floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NoteEdit()));
            },
            backgroundColor: Color.fromARGB(255, 160, 171, 221),
            heroTag: "AddNote",
            child: Image.asset('assets/images/add.png')));
  }
}
