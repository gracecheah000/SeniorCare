// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seniorcare/services/server_api.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';

class MedicationSettings extends StatefulWidget {
  final String elderlyId;
  final String registrationToken;
  const MedicationSettings(
      {super.key, required this.elderlyId, required this.registrationToken});

  @override
  State<MedicationSettings> createState() => _MedicationSettingsState();
}

class _MedicationSettingsState extends State<MedicationSettings> {
  final breakfast = TextEditingController();
  final lunch = TextEditingController();
  final dinner = TextEditingController();
  List<String> updatedMealTimings = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future<dynamic> mealTimings = getMealTimings();

    return FutureBuilder(
        future: mealTimings,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (breakfast.text == '' && lunch.text == '' && dinner.text == '') {
              breakfast.text = snapshot.data[0];
              lunch.text = snapshot.data[1];
              dinner.text = snapshot.data[2];
            }

            return Scaffold(
                backgroundColor: Colors.white,
                appBar: SeniorCareAppBar(start: false),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
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
                                            color: const Color.fromRGBO(
                                                108, 99, 255, 1),
                                            width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(25))),
                                    child: const Center(
                                        child: Text("Medication Settings",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    108, 99, 255, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                            textAlign: TextAlign.center)))),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.1,
                                    top: size.height * 0.06,
                                    right: size.width * 0.1),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Breakfast\ntiming'.toUpperCase(),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 29, 77, 145),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: size.width * 0.45,
                                          child: TextField(
                                              controller: breakfast,
                                              decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 29, 77, 145)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 29, 77, 145)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  labelText: 'Time',
                                                  labelStyle:
                                                      TextStyle(color: Color.fromARGB(255, 29, 77, 145))),
                                              readOnly: true,
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                        context: context,
                                                        initialEntryMode:
                                                            TimePickerEntryMode
                                                                .inputOnly);

                                                if (pickedTime != null) {
                                                  DateTime parsedTime =
                                                      DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                          pickedTime.hour,
                                                          pickedTime.minute);
                                                  String formattedTime =
                                                      DateFormat("h:mma")
                                                          .format(parsedTime);

                                                  setState(() {
                                                    breakfast.text =
                                                        formattedTime;
                                                  });
                                                }
                                              }))
                                    ])),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.1,
                                    top: size.height * 0.06,
                                    right: size.width * 0.1),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Lunch\ntiming'.toUpperCase(),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 29, 77, 145),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: size.width * 0.45,
                                          child: TextField(
                                              controller: lunch,
                                              decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 29, 77, 145)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 29, 77, 145)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  labelText: 'Time',
                                                  labelStyle:
                                                      TextStyle(color: Color.fromARGB(255, 29, 77, 145))),
                                              readOnly: true,
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                        context: context,
                                                        initialEntryMode:
                                                            TimePickerEntryMode
                                                                .inputOnly);

                                                if (pickedTime != null) {
                                                  DateTime parsedTime =
                                                      DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                          pickedTime.hour,
                                                          pickedTime.minute);
                                                  String formattedTime =
                                                      DateFormat("h:mma")
                                                          .format(parsedTime);

                                                  setState(() {
                                                    lunch.text = formattedTime;
                                                  });
                                                }
                                              }))
                                    ])),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.1,
                                    top: size.height * 0.06,
                                    right: size.width * 0.1),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Dinner\ntiming'.toUpperCase(),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 29, 77, 145),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: size.width * 0.45,
                                          child: TextField(
                                              controller: dinner,
                                              decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 29, 77, 145)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 29, 77, 145)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  labelText: 'Time',
                                                  labelStyle:
                                                      TextStyle(color: Color.fromARGB(255, 29, 77, 145))),
                                              readOnly: true,
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                        context: context,
                                                        initialEntryMode:
                                                            TimePickerEntryMode
                                                                .inputOnly);

                                                if (pickedTime != null) {
                                                  DateTime parsedTime =
                                                      DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                          pickedTime.hour,
                                                          pickedTime.minute);
                                                  String formattedTime =
                                                      DateFormat("h:mma")
                                                          .format(parsedTime);

                                                  setState(() {
                                                    dinner.text = formattedTime;
                                                  });
                                                }
                                              }))
                                    ]))
                          ]),
                      Padding(
                          padding: EdgeInsets.fromLTRB(size.width * 0.3,
                              size.height * 0.02, 0, size.height * 0.02),
                          child: FloatingActionButton.extended(
                              heroTag: "Save",
                              onPressed: () async {
                                updatedMealTimings = [
                                  breakfast.text,
                                  lunch.text,
                                  dinner.text
                                ];

                                var result =
                                    await UserDetails.editElderlyMealTimings(
                                        widget.elderlyId, updatedMealTimings);

                                if (result != true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Please try again'),
                                          duration: Duration(seconds: 2)));
                                } else {
                                  ServerApi.updateMedicationNotificationPush(
                                      widget.registrationToken);
                                  print('updated');
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Update successful'),
                                          duration: Duration(seconds: 2)));
                                }
                              },
                              label: const Text('    SAVE    ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                              backgroundColor:
                                  const Color.fromRGBO(108, 99, 255, 1)))
                    ]));
          }
        }));
  }

  getMealTimings() async {
    Map elderlyDetails =
        await UserDetails.getUserDetailsWithId(widget.elderlyId);
    return elderlyDetails['meal timings'];
  }
}
