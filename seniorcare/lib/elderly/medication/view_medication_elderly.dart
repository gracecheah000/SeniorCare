// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/models/medication.dart';
import 'package:seniorcare/services/medication.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:seniorcare/widgets/medication_card_elderly.dart';

class ViewMedicationElderly extends StatefulWidget {
  const ViewMedicationElderly({super.key, required this.userId, this.payload});

  final String userId;
  final String? payload;

  @override
  State<ViewMedicationElderly> createState() => _ViewMedicationElderlyState();
}

class _ViewMedicationElderlyState extends State<ViewMedicationElderly> {
  int _currentMedicationIndex = 0;
  PageController medicationController = PageController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List<T> listToMap<T>(List list, Function handler) {
      List<T> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }
      return result;
    }

    if (widget.payload != null) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: const SeniorCareAppBar(start: false),
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.05, size.height * 0.01, 0, 0),
                    height: size.height * 0.065,
                    width: 150,
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
                            child: Text("Medication",
                                style: TextStyle(
                                    color: Color.fromRGBO(108, 99, 255, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                textAlign: TextAlign.center)))),
                FutureBuilder(
                    future: UserDetails.getUserDetailsWithId(widget.userId),
                    builder: (((context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                            height: size.height * 0.7,
                            child: const CircularProgressIndicator(
                                color: Color.fromARGB(255, 29, 77, 145)));
                      } else {
                        List<dynamic> medicationIdList =
                            (snapshot.data! as Map)['medication'];

                        if (medicationIdList.isEmpty) {
                          return SizedBox(
                              height: size.height * 0.7,
                              child: const Center(
                                  child: Text('No medications yet')));
                        } else {
                          Future<dynamic> medications =
                              getElderlyMedication(medicationIdList);

                          return FutureBuilder(
                              future: medications,
                              builder: (((context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  List<Medication> listOfMedication = snapshot
                                      .data!
                                      .where((i) =>
                                          (widget.payload!.contains(
                                              i.medicationFrequency)) &
                                          (i.status == 'ongoing'))
                                      .toList();
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.03),
                                      child: Column(children: <Widget>[
                                        CarouselSlider(
                                            items: listOfMedication
                                                .map<Widget>((medication) {
                                              return SizedBox(
                                                  height: size.height * 0.30,
                                                  width: size.width,
                                                  child: Container(
                                                      color: Colors.white,
                                                      child: ElderlyMedicationCard(
                                                          medication:
                                                              medication,
                                                          medicationId:
                                                              listOfMedication[
                                                                      _currentMedicationIndex]
                                                                  .medicationId!,
                                                          elderlyId:
                                                              widget.userId,
                                                          payload: true)));
                                            }).toList(),
                                            options: CarouselOptions(
                                                enableInfiniteScroll: false,
                                                height: size.height * 0.72,
                                                onPageChanged:
                                                    ((index, reason) {
                                                  setState(() {
                                                    _currentMedicationIndex =
                                                        index;
                                                  });
                                                }))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: listToMap<Widget>(
                                                listOfMedication, (index, url) {
                                              return Container(
                                                  width: 10,
                                                  height: 10,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 2),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          _currentMedicationIndex ==
                                                                  index
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  29,
                                                                  77,
                                                                  145)
                                                              : Colors.grey));
                                            }))
                                      ]));
                                }
                              })));
                        }
                      }
                    })))
              ])));
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: const SeniorCareAppBar(start: false),
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.05, size.height * 0.01, 0, 0),
                    height: size.height * 0.065,
                    width: 150,
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
                            child: Text("Medication",
                                style: TextStyle(
                                    color: Color.fromRGBO(108, 99, 255, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                textAlign: TextAlign.center)))),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.userId)
                        .snapshots(),
                    builder: (((context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                            height: size.height * 0.7,
                            child: const CircularProgressIndicator(
                                color: Color.fromARGB(255, 29, 77, 145)));
                      } else {
                        List<dynamic> medicationIdList =
                            snapshot.data!.data()!['medication'];

                        if (medicationIdList.isEmpty) {
                          return SizedBox(
                              height: size.height * 0.7,
                              child: const Center(
                                  child: Text('No current medication',
                                      style: TextStyle(fontSize: 18))));
                        } else {
                          Future<dynamic> medications =
                              getElderlyMedication(medicationIdList);

                          return FutureBuilder(
                              future: medications,
                              builder: (((context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.03),
                                      child: Column(children: <Widget>[
                                        CarouselSlider(
                                            items: snapshot.data!
                                                .map<Widget>((medication) {
                                              return SizedBox(
                                                  height: size.height * 0.30,
                                                  width: size.width,
                                                  child: Container(
                                                      color: Colors.white,
                                                      child: ElderlyMedicationCard(
                                                          medication:
                                                              medication,
                                                          medicationId:
                                                              medicationIdList[
                                                                  _currentMedicationIndex],
                                                          elderlyId:
                                                              widget.userId)));
                                            }).toList(),
                                            options: CarouselOptions(
                                                enableInfiniteScroll: false,
                                                height: size.height * 0.72,
                                                onPageChanged:
                                                    ((index, reason) {
                                                  setState(() {
                                                    _currentMedicationIndex =
                                                        index;
                                                  });
                                                }))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: listToMap<Widget>(
                                                snapshot.data, (index, url) {
                                              return Container(
                                                  width: 10,
                                                  height: 10,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 2),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          _currentMedicationIndex ==
                                                                  index
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  29,
                                                                  77,
                                                                  145)
                                                              : Colors.grey));
                                            }))
                                      ]));
                                }
                              })));
                        }
                      }
                    })))
              ])));
    }
  }

  getElderlyMedication(List<dynamic> medicationIdList) async {
    List<Medication> medicationList = [];

    for (String medicationId in medicationIdList) {
      Map details = await MedicationServices.getMedicationDetails(medicationId);
      Medication medication = Medication(
          status: details['status'],
          medicationId: medicationId,
          medicationName: details['name'],
          medicationFrequency: details['frequency'],
          medicationQuantity: details['quantity'],
          medicationTime: details['timing'],
          medicationImage: details['image'],
          medicationPrescription: details['prescription'],
          otherDescription: details['other details']);
      medicationList.add(medication);
    }
    return medicationList;
  }
}
