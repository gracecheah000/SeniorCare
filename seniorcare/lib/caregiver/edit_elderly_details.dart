import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/appbar.dart';

class EditElderlyProfile extends StatefulWidget {
  const EditElderlyProfile({super.key});

  @override
  State<EditElderlyProfile> createState() => _EditElderlyProfileState();
}

class _EditElderlyProfileState extends State<EditElderlyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false, profile: true),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                  height: 120,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(251, 228, 201, 1))),
              Positioned(
                  child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
                  CircleAvatar(
                      backgroundColor: Color.fromRGBO(251, 228, 201, 1),
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 70.0,
                        backgroundImage: getPicture('grace'),
                        backgroundColor: Color.fromRGBO(251, 228, 201, 1),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getName('grace'),
                      SizedBox(
                          height: 60,
                          width: 60,
                          child: IconButton(
                            icon: Image.asset('assets/images/edit.png'),
                            iconSize: 1,
                            onPressed: () {},
                          ))
                    ],
                  )
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
