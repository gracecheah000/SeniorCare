// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/widgets/custom_text_field.dart';
import '../widgets/appbar.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

//todo: create TextEditingController and get values, check and send to backend
class _ForgetPasswordState extends State<ForgetPassword> {
  final email = TextEditingController();

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
                const Text('FORGET PASSWORD',
                    style: TextStyle(
                        color: Color.fromRGBO(105, 100, 173, 1),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
                const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 40,
                    endIndent: 40,
                    color: Color.fromRGBO(108, 99, 255, 1))
              ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, size.height * 0.03, 0, 0)),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.07,
                      vertical: size.height * 0.02),
                  child: customTextField(
                      controller: email, hint: 'Please enter your email')),
              const Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
              FloatingActionButton.extended(
                  heroTag: "ResetPassword",
                  onPressed: () async {
                    if (email.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your email is empty')));
                    } else {
                      final status =
                          await Authentication.resetPassword(email: email.text);
                      if (status == AuthorizationStatus.authorized) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Reset link has been sent to your email!')));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Something went wrong! Please try again.')));
                      }
                    }
                  },
                  label: const Text('    RESET    ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat')),
                  backgroundColor: const Color.fromRGBO(108, 99, 255, 1))
            ]))));
  }
}
