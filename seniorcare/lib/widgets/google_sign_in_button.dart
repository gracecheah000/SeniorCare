import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/services/authentication.dart';
import 'package:seniorcare/caregiver/home_caregiver.dart';
import 'package:seniorcare/authentication/user_info.dart';

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
                      Authentication.registerUserDate(user);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FirstTimeUserInfo(
                          googleUser: user,
                        ),
                      ));
                    } else {
                      bool firstTimeLogin =
                          await Authentication.checkFirstTimeLogIn(user);
                      if (firstTimeLogin == true) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FirstTimeUserInfo(
                            googleUser: user,
                          ),
                        ));
                      } else {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeCaregiver(googleUser: user);
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
