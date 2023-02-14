// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/authentication/forget_password.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/custom_text_field.dart';
import 'package:seniorcare/widgets/google_sign_in_button.dart';

import '../caregiver/home_caregiver.dart';
import '../elderly/home_elderly.dart';
import '../widgets/appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? role = 'Elderly';

  List<DropdownMenuItem<String>> roleMenuItems = Constants.roleMenuItems;

  final email = TextEditingController();
  final password = TextEditingController();
  Future? _future;

  @override
  void initState() {
    _future = Authentication.initializeFirebase(start: false, context: context);
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
                const Text('LOGIN',
                    style: TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
                Divider(
                    height: 20,
                    thickness: 1,
                    indent: size.width * 0.1,
                    endIndent: size.width * 0.1,
                    color: const Color.fromRGBO(108, 99, 255, 1))
              ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, size.height * 0.03, 0, 0)),
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
                        obscureTextNeeded: true)),
                Container(
                    width: size.width * 0.8,
                    height: size.height * 0.04,
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(108, 99, 255, 1))),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgetPassword()));
                        },
                        child: const Text('Forget Password')))
              ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, size.height * 0.08, 0, 0)),
              FloatingActionButton.extended(
                  heroTag: "Login",
                  onPressed: () async {
                    if (email.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill up the email")));
                    } else if (password.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill up the password")));
                    } else {
                      try {
                        User user =
                            await Authentication.signInWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                                context: context);

                        String firstTimeLogin =
                            await Authentication.checkFirstTimeLogIn(user);

                        if (firstTimeLogin == 'elderly') {
                          List elderlyDetails =
                              await UserDetails.getUserDetailsWithEmail(
                                  user.email!);
                          Elderly elderlyUser = Elderly(
                              id: elderlyDetails[0],
                              email: elderlyDetails[1]['email'],
                              mealTimings: elderlyDetails[1]['meal timings']);
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return HomeElderly(user: elderlyUser);
                          }), (r) {
                            return false;
                          });
                        } else if (firstTimeLogin == 'caregiver') {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return HomeCaregiver(
                                userEmail: user.email.toString());
                          }), (r) {
                            return false;
                          });
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("No user found for that email")));
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Wrong password provided for the user")));
                        }
                      }
                    }
                  },
                  label: const Text('    LOGIN    ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat')),
                  backgroundColor: const Color.fromRGBO(108, 99, 255, 1)),
              Padding(padding: EdgeInsets.only(top: size.height * 0.04)),
              const Text('Or login using social media',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              FutureBuilder(
                  future: _future,
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return const GoogleSignInButton();
                    }
                    return const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white));
                  }))
            ]))));
  }
}
