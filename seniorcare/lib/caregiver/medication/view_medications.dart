import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/models/medication.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/medication.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/caregiver/medication/add_medication.dart';
import 'package:seniorcare/caregiver/medication/medication_settings.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:seniorcare/widgets/medication_card.dart';

class ViewMedication extends StatefulWidget {
  const ViewMedication({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<ViewMedication> createState() => _ViewMedicationState();
}

class _ViewMedicationState extends State<ViewMedication> {
  int _currentMedicationIndex = 0;
  PageController medicationController = PageController();
  Elderly? selectedElderly;
  int elderlyIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future<dynamic> caregiverElderlyList = getElderlyList();

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

              // ignore: prefer_conditional_assignment
              if (selectedElderly == null) {
                selectedElderly = elderlyList[0];
              }

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              padding: const EdgeInsets.fromLTRB(35, 10, 0, 0),
                              height: size.height * 0.07,
                              width: size.width * 0.5,
                              color: Colors.transparent,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              108, 99, 255, 1),
                                          width: 2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: DropdownButton<Elderly>(
                                      isExpanded: true,
                                      value: selectedElderly,
                                      style: const TextStyle(
                                          color:
                                              Color.fromRGBO(108, 99, 255, 1),
                                          fontFamily: 'Montserrat',
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis),
                                      onChanged: (Elderly? value) {
                                        setState(() {
                                          selectedElderly = value;
                                          elderlyIndex = elderlyList.indexOf(
                                              selectedElderly as Elderly);
                                        });
                                      },
                                      items: elderlyList.map((Elderly elderly) {
                                        return DropdownMenuItem<Elderly>(
                                            value: elderly,
                                            child: Text(
                                              elderly.name
                                                  .toString()
                                                  .toUpperCase(),
                                            ));
                                      }).toList(),
                                      underline: Container(),
                                      icon: const Icon(Icons.arrow_drop_down,
                                          color: Color.fromRGBO(
                                              108, 99, 255, 1))))),
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    splashRadius: 15,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  AddMedication(
                                                    elderly: selectedElderly,
                                                  ))));
                                    },
                                    icon: Image.asset('assets/images/add.png',
                                        scale: 20),
                                    iconSize: 20,
                                  )),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 30, 0),
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    splashRadius: 15,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  MedicationSettings(
                                                    elderlyId: selectedElderly!
                                                        .id
                                                        .toString(),
                                                  ))));
                                    },
                                    icon: Image.asset(
                                        'assets/images/settings.png',
                                        scale: 1),
                                    iconSize: 60,
                                  )),
                            ],
                          )
                        ]),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .doc(selectedElderly!.id)
                            .snapshots(),
                        builder: (((context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox(
                                height: size.height * 0.7,
                                child: const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 29, 77, 145),
                                ));
                          } else {
                            List<dynamic> medicationIdList =
                                snapshot.data!.data()!['medication'];

                            if (medicationIdList.isEmpty) {
                              return SizedBox(
                                  height: size.height * 0.7,
                                  child: const Center(
                                      child: Text(
                                    'No medications yet',
                                  )));
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
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          children: <Widget>[
                                            CarouselSlider(
                                              items: snapshot.data!
                                                  .map<Widget>((medication) {
                                                return SizedBox(
                                                    height: size.height * 0.30,
                                                    width: size.width,
                                                    child: Container(
                                                        color: Colors.white,
                                                        child: MedicationCard(
                                                          medication:
                                                              medication,
                                                          medicationId:
                                                              medicationIdList[
                                                                  _currentMedicationIndex],
                                                          elderlyId:
                                                              selectedElderly!
                                                                  .id
                                                                  .toString(),
                                                        )));
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
                                                  })),
                                            ),
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
                                                              : Colors.grey),
                                                );
                                              }),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  })));
                            }
                          }
                        })))
                  ]);
            }
          })),
    );
  }

  getElderlyList() async {
    var userId = await UserDetails.getUserId(widget.userEmail);
    Map details = await UserDetails.getUserDetails(userId);
    List<dynamic> elderlyList = details['elderly'];

    List<Elderly> elderlyDetails = [];

    for (var element in elderlyList) {
      Map details = await UserDetails.getUserDetails(element);
      Elderly elderly =
          Elderly(email: details['email'], name: details['name'], id: element);
      elderlyDetails.add(elderly);
    }

    return elderlyDetails;
  }

  getElderlyMedication(List<dynamic> medicationIdList) async {
    List<Medication> medicationList = [];

    for (String medicationId in medicationIdList) {
      Map details = await MedicationServices.getMedicationDetails(medicationId);
      Medication medication = Medication(
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
