import 'package:flutter/material.dart';

class CaregiverDetails extends StatelessWidget {
  CaregiverDetails({super.key, required this.number});

  final TextEditingController name = new TextEditingController();
  final TextEditingController phoneNumber = new TextEditingController();
  final int? number;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListBody(
      children: <Widget>[
        Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Caregiver $number',
                    style: const TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  )
                ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 10),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            width: 1, color: Color.fromRGBO(108, 99, 255, 1))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            width: 2, color: Color.fromRGBO(105, 100, 173, 1))),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 255, 104, 99))),
                    hintText: 'Name',
                    hintStyle: const TextStyle(
                        color: Color.fromRGBO(108, 99, 255, 1))),
                style: const TextStyle(color: Color.fromRGBO(105, 100, 173, 1)),
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: TextField(
                  controller: phoneNumber,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromRGBO(108, 99, 255, 1))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(105, 100, 173, 1))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 255, 104, 99))),
                      hintText: 'Phone Number',
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(108, 99, 255, 1))),
                  style:
                      const TextStyle(color: Color.fromRGBO(105, 100, 173, 1)),
                  keyboardType: TextInputType.phone,
                ))
          ],
        )
      ],
    ));
  }
}
