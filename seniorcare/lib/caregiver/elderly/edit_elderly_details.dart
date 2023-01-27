import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:seniorcare/widgets/custom_text_field.dart';
import 'package:seniorcare/widgets/elderly_details_card.dart';

class EditElderlyProfile extends StatefulWidget {
  const EditElderlyProfile({
    super.key,
    required this.caregiverData,
  });

  final Map caregiverData;

  @override
  State<EditElderlyProfile> createState() => _EditElderlyProfileState();
}

class _EditElderlyProfileState extends State<EditElderlyProfile> {
  final emailController = TextEditingController();
  final pinController = TextEditingController();
  Future<dynamic>? caregiverElderlyDetails;

  @override
  void initState() {
    emailController.text = '';
    pinController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: widget.caregiverData['email'])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            caregiverElderlyDetails =
                getElderlyDetails(snapshot.data!.docs.first['elderly']);
            return FutureBuilder(
                future: caregiverElderlyDetails,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      child: Image.asset(
                                                          'assets/images/caregiver.png')))),
                                          Flexible(
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: size.width * 0.04),
                                                  child: Text(
                                                      (widget.caregiverData[
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
                              ...snapshot.data!.map((elderly) => Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      size.width * 0.05,
                                      size.height * 0.03,
                                      size.width * 0.05,
                                      0),
                                  child: ElderlyDetailsCard(
                                      elderly: elderly,
                                      caregiverEmail:
                                          widget.caregiverData['email'],
                                      notifyParent: updateParent))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.1))
                            ])),
                        floatingActionButton: FloatingActionButton.extended(
                            onPressed: () async {
                              var caregiverId = await UserDetails.getUserId(
                                  widget.caregiverData['email']);
                              _showAddElderlyDialog(caregiverId);
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 176, 200, 233),
                            heroTag: "AddElderly",
                            label: const Text("ADD ELDERLY",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))));
                  }
                });
          }
        });
  }

  _showAddElderlyDialog(String caregiverId) async {
    await showDialog(
        context: context,
        builder: ((context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                scrollable: true,
                backgroundColor: const Color.fromARGB(255, 247, 249, 250),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Column(children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Add Elderly',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 77, 145),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                emailController.clear();
                                pinController.clear();
                                Navigator.pop(context);
                              },
                              icon: Image.asset('assets/images/close_blue.png'),
                              iconSize: 45)
                        ]),
                    const Divider(
                      color: Color.fromARGB(255, 29, 77, 145),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    customTextField(
                        color: const Color.fromARGB(255, 29, 77, 145),
                        controller: emailController,
                        hint: "Elderly's Email"),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    customTextField(
                        color: const Color.fromARGB(255, 29, 77, 145),
                        controller: pinController,
                        hint: "Secret PIN (Given in Elderly's Profile)"),
                  ]);
                }),
                actions: [
                  TextButton(
                      onPressed: () async {
                        if (emailController.text.isEmpty ||
                            pinController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Please fill up elderly's email and secret pin"),
                              duration: Duration(seconds: 2)));

                          return;
                        } else {
                          var success = await UserDetails.addNewElderly(
                              caregiverId,
                              emailController.text,
                              pinController.text);

                          if (success) {
                            emailController.clear();
                            pinController.clear();
                            Navigator.pop(context);
                            return;
                          } else if (!success) {
                            emailController.clear();
                            pinController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "The email or PIN is wrong. Please check again."),
                                    duration: Duration(seconds: 2)));
                          } else {
                            emailController.clear();
                            pinController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(success + '. Please try again'),
                                duration: Duration(seconds: 2)));
                          }
                        }
                      },
                      child: const Text('Add',
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 77, 145),
                              fontSize: 18)))
                ])));
  }

  getElderlyDetails(List<dynamic> caregiverElderlyList) async {
    var elderlyDetails = [];

    if (caregiverElderlyList.isNotEmpty) {
      List<dynamic> elderlyList = caregiverElderlyList;

      for (String element in elderlyList) {
        Map details = await UserDetails.getUserDetails(element);
        Elderly elderly = Elderly(
            email: details['email'],
            name: details['name'],
            age: details['age'],
            sex: details['sex'],
            address: details['address'],
            healthRisks: details['health risks'],
            additionalDetails: details['additional details']);
        elderlyDetails.add(elderly);
      }
    }
    return elderlyDetails;
  }

  updateParent() {
    setState(() {});
  }
}
