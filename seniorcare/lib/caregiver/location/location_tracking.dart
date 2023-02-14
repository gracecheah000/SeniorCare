// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, depend_on_referenced_packages, prefer_conditional_assignment

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTracking extends StatefulWidget {
  const LocationTracking({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<LocationTracking> createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {
  final Location location = Location();
  GoogleMapController? mapController;
  bool _added = false;

  Elderly? selectedElderly;
  int elderlyIndex = 0;

  @override
  Widget build(BuildContext context) {
    Future<dynamic> caregiverElderlyList = getElderlyList();
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
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

                return Stack(children: <Widget>[
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .doc(selectedElderly!.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (_added) {
                          myMap(snapshot);
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      snapshot.data!.data()!['latitude'],
                                      snapshot.data!.data()!['longitude']),
                                  zoom: 17.0),
                              mapType: MapType.normal,
                              onMapCreated:
                                  (GoogleMapController controller) async {
                                setState(() {
                                  mapController = controller;
                                  _added = true;
                                });
                              },
                              markers: {
                                Marker(
                                    markerId: const MarkerId('elderly'),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueMagenta),
                                    position: LatLng(
                                        snapshot.data!.data()!['latitude'],
                                        snapshot.data!.data()!['longitude']))
                              });
                        }
                      }),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                      height: size.height * 0.07,
                      width: size.width * 0.4,
                      alignment: Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromRGBO(108, 99, 255, 1),
                                  width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          child: DropdownButton<Elderly>(
                              isExpanded: true,
                              value: selectedElderly,
                              style: const TextStyle(
                                  color: Color.fromRGBO(108, 99, 255, 1),
                                  fontFamily: 'Montserrat',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                              onChanged: (Elderly? value) {
                                setState(() {
                                  selectedElderly = value;
                                  elderlyIndex = elderlyList
                                      .indexOf(selectedElderly as Elderly);
                                });
                              },
                              items: elderlyList.map((Elderly elderly) {
                                return DropdownMenuItem<Elderly>(
                                    value: elderly,
                                    child: Text(
                                        elderly.name.toString().toUpperCase()));
                              }).toList(),
                              underline: Container(),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Color.fromRGBO(108, 99, 255, 1)))))
                ]);
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

  Future<void> myMap(AsyncSnapshot snapshot) async {
    await mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(snapshot.data.data()['latitude'],
                snapshot.data!.data()!['longitude']),
            zoom: 17.0)));
  }
}
