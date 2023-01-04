// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/widgets/google_sign_in_button.dart';

import '../widgets/appbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // can be used to validate the form
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SeniorCareAppBar(start: false),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(children: <Widget>[
            const Text(
              'REGISTER',
              style: TextStyle(
                  color: Color.fromRGBO(105, 100, 173, 1),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 40,
              endIndent: 40,
              color: Color.fromRGBO(108, 99, 255, 1),
            )
          ]),
          const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
          Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
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
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(108, 99, 255, 1))),
                    style: const TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1))),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
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
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(108, 99, 255, 1))),
                    style: const TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1))),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.fromLTRB(0, 60, 0, 0)),
          FloatingActionButton.extended(
            heroTag: "Register",
            onPressed: () {},
            label: const Text(
              '    REGISTER    ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          const Text('Or register using social media',
              style: TextStyle(fontWeight: FontWeight.bold)),
          FutureBuilder(
              future: Authentication.initializeFirebase(context: context),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('Error initializing Firebase'));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return const GoogleSignInButton();
                }
                return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black));
              }))
        ],
      ))),
    );
  }
}
