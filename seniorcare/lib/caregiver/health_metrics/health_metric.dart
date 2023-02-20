// ignore_for_file: prefer_conditional_assignment, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:seniorcare/widgets/heart_rate_card.dart';
import 'package:seniorcare/widgets/steps_card.dart';

class HealthMetric extends StatefulWidget {
  const HealthMetric({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<HealthMetric> createState() => _HealthMetricState();
}

class _HealthMetricState extends State<HealthMetric> {
  Elderly? selectedElderly;
  int elderlyIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future<dynamic> caregiverElderlyList = getElderlyList();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const SeniorCareAppBar(start: false),
        body: FutureBuilder(
            future: caregiverElderlyList,
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data.isEmpty) {
                return const Center(
                    child: Text('No elderly has been added',
                        style: TextStyle(fontWeight: FontWeight.bold)));
              } else {
                List<Elderly> elderlyList = snapshot.data;

                if (selectedElderly == null) {
                  selectedElderly = elderlyList[0];
                }

                return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user')
                              .doc(selectedElderly!.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                  height: size.height * 0.07,
                                  width: size.width * 0.4,
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.02),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  108, 99, 255, 1),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: DropdownButton<Elderly>(
                                          isExpanded: true,
                                          value: selectedElderly,
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  108, 99, 255, 1),
                                              fontFamily: 'Montserrat',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
                                          onChanged: (Elderly? value) {
                                            setState(() {
                                              selectedElderly = value;
                                              elderlyIndex = elderlyList
                                                  .indexOf(selectedElderly
                                                      as Elderly);
                                            });
                                          },
                                          items: elderlyList
                                              .map((Elderly elderly) {
                                            return DropdownMenuItem<Elderly>(
                                                value: elderly,
                                                child: Text(elderly.name
                                                    .toString()
                                                    .toUpperCase()));
                                          }).toList(),
                                          underline: Container(),
                                          icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Color.fromRGBO(
                                                  108, 99, 255, 1)))));
                            }
                          }),
                      SizedBox(height: size.height * 0.03),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05),
                                child: Card(
                                    color:
                                        const Color.fromARGB(255, 58, 71, 100),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    elevation: 5,
                                    child: StepsHealthCard(
                                        elderlyId: selectedElderly!.id!))),
                            SizedBox(height: size.height * 0.03),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05),
                                child: Card(
                                    color:
                                        const Color.fromARGB(255, 58, 71, 100),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    elevation: 5,
                                    child: HeartRateCard(
                                        elderlyId: selectedElderly!.id!))),
                            SizedBox(height: size.height * 0.03),
                          ])
                    ]));
              }
            })));
  }

  getElderlyList() async {
    List details = await UserDetails.getUserDetailsWithEmail(widget.userEmail);
    List<dynamic> elderlyList = details[1]['elderly'];

    List<Elderly> elderlyDetails = [];

    for (var element in elderlyList) {
      Map details = await UserDetails.getUserDetailsWithId(element);
      Elderly elderly = Elderly(
          email: details['email'],
          name: details['name'],
          id: element,
          registrationToken: details['deviceToken']);
      elderlyDetails.add(elderly);
    }

    return elderlyDetails;
  }
}
