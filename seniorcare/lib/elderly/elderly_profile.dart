// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/appbar.dart';

class ElderlyProfile extends StatefulWidget {
  const ElderlyProfile({super.key});

  @override
  State<ElderlyProfile> createState() => _ElderlyProfileState();
}

class _ElderlyProfileState extends State<ElderlyProfile> {
  @override
  Widget build(BuildContext context) {
    // TODO: add other details
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false, profile: true),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                  height: 270,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(251, 228, 201, 1),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(80)))),
              Positioned(
                  child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 15),
                      child:
                          Text("My Profile", style: TextStyle(fontSize: 18))),
                  CircleAvatar(
                      backgroundColor: Color.fromRGBO(251, 228, 201, 1),
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 70.0,
                        backgroundImage: getPicture('grace'),
                        backgroundColor: Color.fromRGBO(251, 228, 201, 1),
                      )),
                  Padding(padding: EdgeInsets.all(10), child: getName('grace')),
                ],
              )),
            ],
          ),
        ));
  }

  // TODO: get profile details from backend
  // TODO: if no picture uploaded, provide default icon image
  getPicture(String username) {
    return AssetImage('assets/images/profilepic.jpg');
  }

  getName(String username) {
    return Text("Cheah Mun Yan, Grace",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
  }
}
