// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTracking extends StatefulWidget {
  const LocationTracking({super.key});

  @override
  State<LocationTracking> createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {
  static final LatLng _kMapCenter = LatLng(1.290270, 103.851959);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 12.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {
    // TODO: get latest location of elderly
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _kInitialPosition,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                height: 60,
                width: 100,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(108, 99, 255, 1),
                      border: Border.all(
                          color: const Color.fromRGBO(108, 99, 255, 1),
                          width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: const Center(
                      child: Text(
                    "Location",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.center,
                  )),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(120, 620, 0, 0),
                child: FloatingActionButton.extended(
                  heroTag: "SendAlert",
                  onPressed: () {},
                  label: const Text(
                    '  SendAlert  ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
                ))
          ],
        ));
  }
}
