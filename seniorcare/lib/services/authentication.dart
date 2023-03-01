// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seniorcare/caregiver/home_caregiver.dart';
import 'package:seniorcare/authentication/userinfo/user_info.dart';
import 'package:seniorcare/elderly/home_elderly.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/user_details.dart';

class Authentication {
  static Future initializeFirebase(
      {required BuildContext context, required bool start}) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      bool exist = await checkExistingAccount(user);

      if (exist == false) {
        registerUserData(user);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FirstTimeUserInfo(user: user)));
      } else {
        String firstTimeLogin = await checkFirstTimeLogIn(user);

        if (firstTimeLogin == '') {
          if (user.providerData[0].providerId == 'google.com') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FirstTimeUserInfo(user: user)));
          }
        } else if (firstTimeLogin == 'elderly') {
          List elderlyDetails =
              await UserDetails.getUserDetailsWithEmail(user.email!);
          Elderly elderlyUser = Elderly(
              id: elderlyDetails[0],
              email: elderlyDetails[1]['email'],
              mealTimings: elderlyDetails[1]['meal timings']);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomeElderly(user: elderlyUser);
          }), (r) {
            return false;
          });
        } else if (firstTimeLogin == 'caregiver') {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomeCaregiver(userEmail: user.email.toString());
          }), (r) {
            return false;
          });
        }
      }
    }
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

  static Future signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    User? user;

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "The password provided is too weak. The password should at least be 6 chars.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The account already exists for that email")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Firebase error occured registering using email. Try again.")));
    }

    return user;
  }

  static Future signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    User? user;

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;

    return user;
  }

  // check for existing account
  static Future<bool> checkExistingAccount(User user) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: user.email!.toLowerCase())
        .get();

    if (query.docs.isEmpty) {
      return false;
    }
    return true;
  }

  static Future<String> checkFirstTimeLogIn(User user) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: user.email!.toLowerCase())
        .get();

    var data = query.docs.first.data() as Map;
    if (data['role'] == null) {
      return '';
    }
    return data['role'];
  }

  // if account does not exist, register the email user in database
  static registerUserData(User user) async {
    await FirebaseFirestore.instance
        .collection("user")
        .add({'email': user.email!.toLowerCase()});
  }

  static Future<AuthorizationStatus> resetPassword(
      {required String email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    AuthorizationStatus status = AuthorizationStatus.notDetermined;

    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => status = AuthorizationStatus.authorized)
        .catchError((error) => status = AuthorizationStatus.denied);

    return status;
  }
}
