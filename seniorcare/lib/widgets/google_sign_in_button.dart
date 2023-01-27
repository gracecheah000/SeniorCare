// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/elderly/home_elderly.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/caregiver/home_caregiver.dart';
import 'package:seniorcare/authentication/userinfo/user_info.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 15),
        child: _isSigningIn
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(const CircleBorder())),
                onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });

                  User? user =
                      await Authentication.signInWithGoogle(context: context);

                  if (user != null) {
                    bool exist =
                        await Authentication.checkExistingAccount(user);
                    if (exist == false) {
                      Authentication.registerUserData(user);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FirstTimeUserInfo(
                          user: user,
                        ),
                      ));
                    } else {
                      String firstTimeLogin =
                          await Authentication.checkFirstTimeLogIn(user);
                      if (firstTimeLogin == '') {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FirstTimeUserInfo(
                            user: user,
                          ),
                        ));
                      } else if (firstTimeLogin == 'elderly') {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return HomeElderly(userEmail: user.email);
                        }), (r) {
                          return false;
                        });
                      } else if (firstTimeLogin == 'caregiver') {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return HomeCaregiver(userEmail: user.email);
                        }), (r) {
                          return false;
                        });
                      }
                    }
                  }

                  setState(() {
                    _isSigningIn = false;
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Image.asset("assets/images/google_logo.png",
                        height: 35))));
  }
}
