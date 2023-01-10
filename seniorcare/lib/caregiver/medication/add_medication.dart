// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seniorcare/models/medication.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/medication.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:seniorcare/widgets/custom_text_field.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({super.key, required this.elderly});

  final Elderly? elderly;

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

  String? frequency;
  List<DropdownMenuItem<String>> get frequencyDropdownItems {
    List<DropdownMenuItem<String>> frequencyMenuItems = [
      DropdownMenuItem(value: 'Every morning', child: Text('Every morning')),
      DropdownMenuItem(value: 'Every night', child: Text('Every night')),
      DropdownMenuItem(value: 'Twice a day', child: Text('Twice a day')),
      DropdownMenuItem(value: '3 times a day', child: Text('3 times a day')),
    ];
    return frequencyMenuItems;
  }

  String? timing;
  List<DropdownMenuItem<String>> get timingDropdownItems {
    List<DropdownMenuItem<String>> timingMenuItems = [
      DropdownMenuItem(value: 'Before meals', child: Text('Before meals')),
      DropdownMenuItem(value: 'with', child: Text('With meals')),
      DropdownMenuItem(value: 'after', child: Text('After meals')),
    ];
    return timingMenuItems;
  }

  final name = TextEditingController();
  final quantity = TextEditingController();
  final others = TextEditingController();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();

    Future getImageFromCamera() async {
      PickedFile? pickedFile = await ImagePicker().getImage(
          source: ImageSource.camera,
          maxHeight: 1800,
          maxWidth: 1800,
          imageQuality: 25);

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(
                    size.width * 0.1, size.height * 0.02, 0, 0),
                height: size.height * 0.07,
                width: size.width * 0.7,
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
            Center(
                child: Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.03, bottom: size.height * 0.01),
                    child: Text(widget.elderly!.name!.toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 29, 77, 145))))),
            Divider(
              color: Color.fromARGB(255, 29, 77, 145),
              indent: size.width * 0.1,
              endIndent: size.width * 0.1,
              thickness: 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: customTextField(
                        controller: name,
                        color: Color.fromARGB(255, 29, 77, 145),
                        hint: 'Medication Name')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                                color: Color.fromARGB(255, 29, 77, 145))),
                        child: DropdownButton<String>(
                            hint: Text('Frequency',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 29, 77, 145))),
                            isExpanded: true,
                            value: frequency,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 29, 77, 145),
                                fontFamily: 'Montserrat',
                                fontSize: 17),
                            items: frequencyDropdownItems,
                            onChanged: (value) {
                              setState(() {
                                frequency = value;
                              });
                            },
                            underline: Container(),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 29, 77, 145))))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: customTextField(
                        controller: quantity,
                        hint: 'Quantity (each time) - eg. 5ml/1 tablet',
                        color: Color.fromARGB(255, 29, 77, 145))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                                color: Color.fromARGB(255, 29, 77, 145))),
                        child: DropdownButton<String>(
                            hint: Text('Timing',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 29, 77, 145))),
                            isExpanded: true,
                            value: timing,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 29, 77, 145),
                                fontFamily: 'Montserrat',
                                fontSize: 17),
                            items: timingDropdownItems,
                            onChanged: (value) {
                              setState(() {
                                timing = value;
                              });
                            },
                            underline: Container(),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 29, 77, 145))))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Container(
                      width: 500,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 29, 77, 145)),
                          borderRadius: BorderRadius.circular(30)),
                      child: FloatingActionButton.extended(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          onPressed: () {
                            getImageFromCamera();
                          },
                          label: Text('Add Image of medication',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 77, 145)))),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                                color: Color.fromARGB(255, 29, 77, 145))),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            value: toComplete,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 29, 77, 145),
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
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: customTextField(
                        controller: others,
                        hint: 'Others',
                        color: Color.fromARGB(255, 29, 77, 145))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: FloatingActionButton.extended(
                      heroTag: "Add",
                      onPressed: () async {
                        if (name.text.isEmpty ||
                            frequency == null ||
                            quantity.text.isEmpty ||
                            timing == null ||
                            imageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please fill up all necessary fields"),
                                  duration: Duration(seconds: 2)));
                        }
                        final bytes = File(imageFile!.path).readAsBytesSync();
                        String base64Image = base64Encode(bytes);

                        Medication newMedication = Medication(
                            medicationName: name.text,
                            medicationFrequency: frequency.toString(),
                            medicationQuantity: quantity.text,
                            medicationTime: timing.toString(),
                            medicationImage: base64Image,
                            medicationPrescription: toComplete.toString(),
                            otherDescription: others.text);

                        var result = await MedicationServices.saveMedication(
                            widget.elderly!.id!, newMedication);

                        if (result == true) {
                          setState(() {
                            name.clear();
                            frequency = null;
                            quantity.clear();
                            timing = null;
                            imageFile = null;
                            toComplete = 'To Complete';
                            others.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result + '. Please try again'),
                              duration: Duration(seconds: 2)));
                        }
                      },
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
          ],
        )));
  }
}
