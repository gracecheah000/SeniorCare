// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({super.key});

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  String? toComplete = 'To Complete';
  List<DropdownMenuItem<String>> get completeDropdownItems {
    List<DropdownMenuItem<String>> completeMenuItems = [
      DropdownMenuItem(value: 'To Complete', child: Text('To Complete')),
      DropdownMenuItem(
          value: 'Stop Upon Recovery', child: Text('Stop upon recovery'))
    ];
    return completeMenuItems;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    File imageFile;

    getImageFromCamera() async {
      PickedFile? pickedFile = await ImagePicker().getImage(
          source: ImageSource.camera, maxHeight: 1800, maxWidth: 1800);

      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    }

    // TODO: add and push to backend - show success message and remove all fields so that they can add another one if necessary
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(35, 30, 0, 0),
                height: 70,
                width: 250,
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
                    "Add New Medication",
                    style: TextStyle(
                        color: Color.fromRGBO(108, 99, 255, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
                )),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 182, 115, 60))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 117, 66, 25))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 255, 104, 99))),
                          hintText: 'Name of medication',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 182, 115, 60)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 182, 115, 60))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 117, 66, 25))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 255, 104, 99))),
                          hintText: 'Quantity (each time)',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 182, 115, 60)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )),
                  // TODO: dont make it open ended
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 182, 115, 60))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 117, 66, 25))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 255, 104, 99))),
                          hintText: 'Frequency (eg. once a day)',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 182, 115, 60)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 182, 115, 60))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 117, 66, 25))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 255, 104, 99))),
                          hintText: 'Timing (eg. Before/During/After meals)',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 182, 115, 60)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Container(
                        width: 500,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 182, 115, 60)),
                            borderRadius: BorderRadius.circular(30)),
                        child: FloatingActionButton.extended(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            onPressed: () {
                              getImageFromCamera();
                            },
                            label: Text('Add Image of medication',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 182, 115, 60)))),
                      )),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                  color: Color.fromARGB(255, 182, 115, 60))),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              value: toComplete,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 182, 115, 60),
                                  fontFamily: 'Montserrat',
                                  fontSize: 17),
                              items: completeDropdownItems,
                              onChanged: (value) {
                                setState(() {
                                  toComplete = value;
                                });
                              },
                              underline: Container(),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Color.fromARGB(255, 182, 115, 60))))),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 182, 115, 60))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 117, 66, 25))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 255, 104, 99))),
                          hintText: 'Others',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 182, 115, 60)),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: FloatingActionButton.extended(
                        heroTag: "Add",
                        onPressed: () {},
                        label: const Text(
                          '    ADD    ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                        backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
                      ))
                ],
              ),
            ),
          ],
        )));
  }
}
