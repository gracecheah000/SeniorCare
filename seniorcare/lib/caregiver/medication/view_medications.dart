// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:seniorcare/caregiver/medication/medication_card.dart';
import 'package:seniorcare/caregiver/medication/add_medication.dart';
import 'package:seniorcare/caregiver/medication/medication_settings.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ViewMedication extends StatefulWidget {
  const ViewMedication({super.key});

  @override
  State<ViewMedication> createState() => _ViewMedicationState();
}

class _ViewMedicationState extends State<ViewMedication> {
  int _currentMedicationIndex = 0;
  PageController medicationController = PageController();

  @override
  Widget build(BuildContext context) {
    // TODO: get medications from backend and map
    List<MedicationCard> medications = [
      MedicationCard("a-glucosidase inhibitors", "assets/images/map.png",
          "3 times a day", "1 tablet each", "after meals", "To Complete", "-"),
      MedicationCard("vitamin c", "assets/images/pills.png", "2 times a day",
          "1 tablet each", "before meals", "Stop upon recovery", "-"),
    ];

    List<T> map<T>(List list, Function handler) {
      List<T> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }

      return result;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(35, 10, 0, 0),
                    height: 50,
                    width: 170,
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
                        "Medication",
                        style: TextStyle(
                            color: Color.fromRGBO(108, 99, 255, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      )),
                    )),
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => const AddMedication())));
                          },
                          icon: Image.asset('assets/images/add.png', scale: 20),
                          iconSize: 20,
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 30, 0),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) =>
                                    const MedicationSettings())));
                          },
                          icon: Image.asset('assets/images/settings.png',
                              scale: 1),
                          iconSize: 60,
                        )),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  CarouselSlider(
                    items: medications.map((medication) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                              color: Colors.white, child: medication));
                    }).toList(),
                    options: CarouselOptions(
                        enableInfiniteScroll: false,
                        height: 580,
                        onPageChanged: ((index, reason) {
                          setState(() {
                            _currentMedicationIndex = index;
                          });
                        })),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(medications, (index, url) {
                      return Container(
                        width: 10,
                        height: 10,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentMedicationIndex == index
                                ? const Color.fromARGB(255, 182, 115, 60)
                                : Colors.grey),
                      );
                    }),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
