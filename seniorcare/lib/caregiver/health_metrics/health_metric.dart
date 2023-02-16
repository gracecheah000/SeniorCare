// ignore_for_file: prefer_conditional_assignment, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seniorcare/models/health_metrics.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:health/health.dart';
import 'package:seniorcare/widgets/health_card.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HealthMetric extends StatefulWidget {
  const HealthMetric({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<HealthMetric> createState() => _HealthMetricState();
}

class _HealthMetricState extends State<HealthMetric> {
  Elderly? selectedElderly;
  int elderlyIndex = 0;

  List<HealthDataPoint> healthData = [];
  List<Steps> steps = [];
  HealthFactory healthFactory = HealthFactory();

  Future fetchHealthData() async {
    final types = [HealthDataType.HEART_RATE, HealthDataType.STEPS];

    // setting time frame
    final now = DateTime.now();
    int userInput = 2; // to change to a user input

    bool requested = await healthFactory.requestAuthorization(types);

    if (requested) {
      try {
        // fetch heart rate from google fit
        healthData = await healthFactory.getHealthDataFromTypes(
            now.subtract(Duration(days: userInput)),
            now,
            [HealthDataType.HEART_RATE]);

        if (healthData.isNotEmpty) {
          healthData = HealthFactory.removeDuplicates(healthData);
        }

        for (int i = 0; i <= userInput; i++) {
          int? stepOfDay;
          DateTime yest = DateTime(now.year, now.month, now.day);
          Steps step;

          if (i == 0) {
            stepOfDay = await healthFactory.getTotalStepsInInterval(yest, now);

            step = Steps(value: stepOfDay!, dateFrom: yest, dateTo: now);
          } else {
            stepOfDay = await healthFactory.getTotalStepsInInterval(
                yest.subtract(Duration(days: i)),
                yest.subtract(Duration(days: i - 1)));

            step = Steps(
                value: stepOfDay!,
                dateFrom: yest.subtract(Duration(days: userInput)),
                dateTo: yest.subtract(Duration(days: userInput - 1)));
          }

          steps.add(step);
        }

        return [healthData, steps];
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please try again'), duration: Duration(seconds: 2)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please authorize Google Fit permissions in settings'),
          duration: Duration(seconds: 2)));
    }
  }

  @override
  void initState() async {
    super.initState();
    Permission.activityRecognition.request();
    tz.initializeTimeZones();
    final String locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
  }

  @override
  Widget build(BuildContext context) {
    fetchHealthData();
    Future<dynamic> caregiverElderlyList = getElderlyList();

    var size = MediaQuery.of(context).size;

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

                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(selectedElderly!.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
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
                                                  108, 99, 255, 1))))),
                              FutureBuilder(
                                  future: fetchHealthData(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.data.isEmpty) {
                                      return SizedBox(
                                          height: size.height * 0.7,
                                          child: const Center(
                                              child: Text(
                                                  'No health data synced',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))));
                                    } else {
                                      List<Steps> steps = [];
                                      List<HeartRate> heartRates = [];

                                      for (HealthDataPoint h
                                          in snapshot.data[0]) {
                                        if (h.type ==
                                            HealthDataType.HEART_RATE) {
                                          HeartRate heartRate = HeartRate(
                                              value: h.value,
                                              dateFrom: h.dateFrom,
                                              dateTo: h.dateTo);
                                          heartRates.add(heartRate);
                                        }
                                      }
                                      steps = snapshot.data[1];

                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            HealthCard(
                                                dataList: steps,
                                                title: 'Daily Steps')
                                          ]);
                                    }
                                  })
                            ]);
                      }
                    });
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
