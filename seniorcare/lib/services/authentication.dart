import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seniorcare/caregiver/home_caregiver.dart';
import 'package:seniorcare/authentication/user_info.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      bool exist = await checkExistingAccount(user);
      if (exist == false) {
        registerUserDate(user);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FirstTimeUserInfo(
            googleUser: user,
          ),
        ));
      } else {
        bool firstTimeLogin = await checkFirstTimeLogIn(user);
        if (firstTimeLogin == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FirstTimeUserInfo(
              googleUser: user,
            ),
          ));
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomeCaregiver(googleUser: user);
          }), (r) {
            return false;
          });
        }
      }
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    // login with google
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "The account already exists with a different credential")));
        } else if (e.code == 'invalid credential') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Error occurred while accessing credentials. Try again.")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error occured using Google Sign In. Try again.")));
      }
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error signing out. Try again")));
    }
  }

  // check for existing account
  static Future<bool> checkExistingAccount(User user) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: user.email)
        .get();

    if (query.docs.isEmpty) {
      return false;
    }
    return true;
  }

  static Future<bool> checkFirstTimeLogIn(User user) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: user.email)
        .get();

    var data = query.docs.first.data() as Map;
    if (data['role'] == null) {
      return true;
    }
    return false;
  }

  // if account does not exist, register the email user in database
  static void registerUserDate(User user) async {
    await FirebaseFirestore.instance
        .collection("user")
        .add({'email': user.email, 'type': 'google'})
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
