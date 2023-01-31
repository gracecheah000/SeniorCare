// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:seniorcare/widgets/caregiver_details_card.dart';

class ElderlyProfile extends StatefulWidget {
  const ElderlyProfile({super.key, required this.elderlyData});

  final Map elderlyData;

  @override
  State<ElderlyProfile> createState() => _ElderlyProfileState();
}

class _ElderlyProfileState extends State<ElderlyProfile> {
  Future<dynamic>? elderlyCaregiverDetails;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: widget.elderlyData['email'])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            elderlyCaregiverDetails =
                getCaregiverDetails(snapshot.data!.docs.first['caregiver']);

            return FutureBuilder(
                future: elderlyCaregiverDetails,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Scaffold(
                        backgroundColor: Colors.white,
                        appBar:
                            const SeniorCareAppBar(start: false, profile: true),
                        body: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              Stack(children: <Widget>[
                                Container(
                                    height: size.height * 0.1,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 176, 200, 233),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(80)))),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.11),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: size.height * 0.005),
                                              child: CircleAvatar(
                                                  radius: 55,
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 176, 200, 233),
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              237,
                                                              243,
                                                              255),
                                                      radius: 53,
                                                      child: (widget.elderlyData['sex'] ==
                                                              'Female')
                                                          ? Image.asset(
                                                              'assets/images/elderly_female.png')
                                                          : Image.asset(
                                                              'assets/images/elderly_male.png',
                                                              scale: 7.5)))),
                                          Flexible(
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: size.width * 0.04),
                                                  child: Text(
                                                      (widget.elderlyData[
                                                              'name'])
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow: TextOverflow
                                                          .ellipsis)))
                                        ]))
                              ]),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      size.width * 0.08,
                                      size.height * 0.03,
                                      size.width * 0.08,
                                      0),
                                  child: Card(
                                      color: const Color.fromARGB(
                                          255, 237, 243, 255),
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 176, 200, 233)),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: SingleChildScrollView(
                                          child: Column(children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(
                                                top: size.height * 0.02,
                                                bottom: size.height * 0.02),
                                            child: Text('Your Details',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Color.fromARGB(
                                                        255, 29, 77, 145)))),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.06),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: const Color.fromARGB(
                                                              255, 176, 200, 233),
                                                          border: Border.all(
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  176,
                                                                  200,
                                                                  233)),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20)),
                                                      padding: EdgeInsets.only(
                                                          top: size.height * 0.01,
                                                          left: size.width * 0.02,
                                                          bottom: size.height * 0.01,
                                                          right: size.width * 0.02),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                                        Text(
                                                            'age :'
                                                                .toUpperCase(),
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: size
                                                                            .width *
                                                                        0.1)),
                                                        Text(
                                                            widget.elderlyData[
                                                                'age'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15))
                                                      ])),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: const Color.fromARGB(
                                                              255, 176, 200, 233),
                                                          border: Border.all(
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  176,
                                                                  200,
                                                                  233)),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20)),
                                                      padding: EdgeInsets.only(
                                                          top: size.height * 0.01,
                                                          left: size.width * 0.02,
                                                          bottom: size.height * 0.01,
                                                          right: size.width * 0.02),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                                        Text(
                                                            'sex :'
                                                                .toUpperCase(),
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: size
                                                                            .width *
                                                                        0.1)),
                                                        Text(
                                                            widget.elderlyData[
                                                                'sex'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15))
                                                      ]))
                                                ])),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.06,
                                                vertical: size.height * 0.025),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 176, 200, 233),
                                                    border: Border.all(
                                                        color:
                                                            const Color.fromARGB(
                                                                255,
                                                                176,
                                                                200,
                                                                233)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding: EdgeInsets.only(
                                                    top: size.height * 0.01,
                                                    left: size.width * 0.02,
                                                    bottom: size.height * 0.01,
                                                    right: size.width * 0.02),
                                                child:
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                                  Text(
                                                      'address :'.toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: size.width *
                                                              0.1)),
                                                  Text(
                                                      widget.elderlyData[
                                                          'address'],
                                                      style: const TextStyle(
                                                          fontSize: 15))
                                                ]))),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.06),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 176, 200, 233),
                                                    border: Border.all(
                                                        color:
                                                            const Color.fromARGB(
                                                                255,
                                                                176,
                                                                200,
                                                                233)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding: EdgeInsets.only(
                                                    top: size.height * 0.01,
                                                    left: size.width * 0.02,
                                                    bottom: size.height * 0.01,
                                                    right: size.width * 0.02),
                                                child:
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                                  Text(
                                                      'health risks :'
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: size.width *
                                                              0.1)),
                                                  Expanded(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                        for (var item in widget
                                                                .elderlyData[
                                                            'health risks'])
                                                          Text(item,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                              textAlign:
                                                                  TextAlign.end)
                                                      ]))
                                                ]))),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.06,
                                                vertical: size.height * 0.025),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 176, 200, 233),
                                                    border: Border.all(
                                                        color: const Color.fromARGB(
                                                            255, 176, 200, 233)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding: EdgeInsets.only(
                                                  top: size.height * 0.01,
                                                  left: size.width * 0.02,
                                                  bottom: size.height * 0.01,
                                                  right: size.width * 0.02,
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                          'other details :'
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      size.width *
                                                                          0.1)),
                                                      Expanded(
                                                          child: Text(
                                                              widget.elderlyData[
                                                                  'additional details'],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                              textAlign:
                                                                  TextAlign
                                                                      .end))
                                                    ])))
                                      ])))),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.05)),
                              Text('Your Caregivers',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 29, 77, 145))),
                              Divider(
                                  color: Color.fromARGB(255, 29, 77, 145),
                                  indent: size.width * 0.2,
                                  endIndent: size.width * 0.2),
                              ...snapshot.data!.map((caregiver) => Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      size.width * 0.08,
                                      size.height * 0.01,
                                      size.width * 0.08,
                                      size.height * 0.02),
                                  child: CaregiverDetailsCard(
                                      caregiver: caregiver))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.1))
                            ])));
                  }
                });
          }
        });
  }

  getCaregiverDetails(List<dynamic> elderlyCaregiverList) async {
    var caregiverDetails = [];

    if (elderlyCaregiverList.isNotEmpty) {
      for (String element in elderlyCaregiverList) {
        Map details = await UserDetails.getUserDetails(element);
        Caregiver caregiver = Caregiver(
            email: details['email'],
            name: details['name'],
            emergencyContact: details['emergency contact']);
        caregiverDetails.add(caregiver);
      }
    }
    return caregiverDetails;
  }
}
