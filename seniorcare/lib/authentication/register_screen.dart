// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/authentication/userinfo/user_info.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/widgets/custom_text_field.dart';
import 'package:seniorcare/widgets/google_sign_in_button.dart';

import '../widgets/appbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  Future? _future;

  @override
  void initState() {
    _future = Authentication.initializeFirebase(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                Divider(
                  height: 20,
                  thickness: 1,
                  indent: size.width * 0.1,
                  endIndent: size.width * 0.1,
                  color: const Color.fromRGBO(108, 99, 255, 1),
                )
              ]),
              Padding(padding: EdgeInsets.only(top: size.height * 0.04)),
              Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.07,
                        vertical: size.height * 0.01),
                    child: customTextField(controller: email, hint: 'Email')),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.07,
                        vertical: size.height * 0.02),
                    child: customTextField(
                        controller: password,
                        hint: 'Password',
                        obscureTextNeeded: true))
              ]),
              Padding(padding: EdgeInsets.only(top: size.height * 0.04)),
              FloatingActionButton.extended(
                heroTag: "Register",
                onPressed: () async {
                  try {
                    User? user =
                        await Authentication.signUpWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                            context: context);

                    if (user != null) {
                      await Authentication.registerUserData(user);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FirstTimeUserInfo(
                                emailUser: user,
                              )));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Error occurred while creating account. Try again.")));
                  }
                },
                label: const Text(
                  '    REGISTER    ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
              ),
              const Text('Or register using social media',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              FutureBuilder(
                  future: _future,
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: const Text('Error initializing Firebase'));
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return const GoogleSignInButton();
                    }
                    return const CircularProgressIndicator();
                  }))
            ]))));
  }
}
