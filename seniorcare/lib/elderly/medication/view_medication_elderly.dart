// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../widgets/medication_card_elderly.dart';

class ViewMedicationElderly extends StatefulWidget {
  const ViewMedicationElderly({super.key});

  @override
  State<ViewMedicationElderly> createState() => _ViewMedicationElderlyState();
}

class _ViewMedicationElderlyState extends State<ViewMedicationElderly> {
  int _currentMedicationIndex = 0;
  PageController medicationController = PageController();

  @override
  Widget build(BuildContext context) {
    // TODO: get medications from backend and map
    List<ElderlyMedicationCard> medications = [
      ElderlyMedicationCard("a-glucosidase inhibitors", "assets/images/map.png",
          "3 times a day", "1 tablet each", "after meals", "To Complete", "-"),
      ElderlyMedicationCard(
          "vitamin c",
          "assets/images/pills.png",
          "2 times a day",
          "1 tablet each",
          "before meals",
          "Stop upon recovery",
          "-"),
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
            Container(
                padding: const EdgeInsets.fromLTRB(35, 20, 0, 0),
                height: 60,
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
            Padding(
                padding: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
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
                            height: 550,
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
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentMedicationIndex == index
                                    ? Color.fromARGB(255, 182, 115, 60)
                                    : Colors.grey),
                          );
                        }),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
