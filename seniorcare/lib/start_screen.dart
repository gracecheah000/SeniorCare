// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.title});

  final String title;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Text('Senior', style: TextStyle(color: Colors.black)),
            const Text('Care',
                style: TextStyle(color: Color.fromRGBO(180, 107, 237, 1)))
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
