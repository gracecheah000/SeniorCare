// ignore_for_file: depend_on_referenced_packages, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:seniorcare/models/medication.dart';
import 'package:seniorcare/services/medication.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:seniorcare/caregiver/medication/medication_card.dart';

class PastMedication extends StatefulWidget {
  const PastMedication({super.key, required this.elderlyId});

  final String elderlyId;

  @override
  State<PastMedication> createState() => _PastMedicationState();
}

class _PastMedicationState extends State<PastMedication> {
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

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const SeniorCareAppBar(start: false),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(
                      size.width * 0.05, size.height * 0.01, 0, 0),
                  height: size.height * 0.06,
                  width: size.width * 0.55,
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
                          child: Text("Past Medication",
                              style: TextStyle(
                                  color: Color.fromRGBO(108, 99, 255, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.center)))),
              FutureBuilder(
                  future: getElderlyMedication(widget.elderlyId),
                  builder: (((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 20),
                          child: Column(children: <Widget>[
                            CarouselSlider(
                                items: (snapshot.data! as List)
                                    .map<Widget>((medication) {
                                  return SizedBox(
                                      height: size.height * 0.30,
                                      width: size.width,
                                      child: Container(
                                          color: Colors.white,
                                          child: MedicationCard(
                                              medication: medication,
                                              elderlyId: widget.elderlyId)));
                                }).toList(),
                                options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    height: size.height * 0.7,
                                    onPageChanged: ((index, reason) {
                                      setState(() {
                                        _currentMedicationIndex = index;
                                      });
                                    }))),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: listToMap<Widget>(
                                    snapshot.data as List, (index, url) {
                                  return Container(
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 2),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              _currentMedicationIndex == index
                                                  ? const Color.fromARGB(
                                                      255, 29, 77, 145)
                                                  : Colors.grey));
                                }))
                          ]));
                    }
                  })))
            ]));
  }

  getElderlyMedication(String elderlyId) async {
    List<dynamic> medicationIdList =
        (await UserDetails.getUserDetailsWithId(elderlyId))['past medication'];
    List<Medication> medicationList = [];

    for (String medicationId in medicationIdList) {
      Map details = await MedicationServices.getMedicationDetails(medicationId);
      Medication medication = Medication(
          medicationId: medicationId,
          medicationName: details['name'],
          medicationFrequency: details['frequency'],
          medicationQuantity: details['quantity'],
          medicationTime: details['timing'],
          medicationImage: details['image'],
          medicationPrescription: details['prescription'],
          otherDescription: details['other details'],
          startDate: details['start date'],
          endDate: details['end date']);
      medicationList.add(medication);
    }
    return medicationList;
  }
}
