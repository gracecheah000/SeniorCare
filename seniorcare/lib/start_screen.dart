// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:seniorcare/authentication/login_screen.dart';
import 'package:seniorcare/authentication/register_screen.dart';
import 'package:seniorcare/widgets/appbar.dart';

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
        backgroundColor: Colors.white,
        appBar: const SeniorCareAppBar(start: true),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/startScreen.png',
              height: 300,
              width: 300,
            ),
            const Text('Nurturing is not complex',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
            const Text('To care for those who once cared for us',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 13)),
            const Padding(padding: EdgeInsets.fromLTRB(0, 150, 0, 0)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: "signUp",
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                    },
                    label: const Text('   SIGN UP   '),
                    backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
                  ),
                  FloatingActionButton.extended(
                    heroTag: "login",
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                    label: const Text('    LOGIN    '),
                    backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
                  )
                ])
          ],
        )));
  }
}
