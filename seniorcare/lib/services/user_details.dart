import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorcare/models/user.dart';

class UserDetails {
  static void saveElderlyDetails(Elderly user, User? googleUser) async {
    DocumentReference ref;
    String userId;

    if (googleUser != null) {
      userId = await getUserId(googleUser.email);
    } else {
      userId = await getUserId(user.email);
    }

    ref = FirebaseFirestore.instance.collection('user').doc(userId);

    await ref.update({
      'name': user.name,
      'age': user.age,
      'sex': user.sex,
      'address': user.address,
      'health risks': user.healthRisks,
      'additional details': user.additionalDetails,
      'role': 'elderly',
      'caregiver': [],
      'medication': [],
      'appointment': [],
      'pin': Random().nextInt(999999),
      'meal timings': ['7:00AM', '12:00PM', '7:00PM']
    });
  }

  static void editElderlyDetails(Elderly user) async {
    DocumentReference ref;
    String userId;

    userId = await getUserId(user.email);

    ref = FirebaseFirestore.instance.collection('user').doc(userId);

    await ref.update({
      'age': user.age,
      'sex': user.sex,
      'address': user.address,
      'health risks': user.healthRisks,
      'additional details': user.additionalDetails,
      'pin': Random().nextInt(999999)
    });
  }

  static addElderlyMedication(String elderlyId, String medicationId) async {
    DocumentReference ref;

    ref = FirebaseFirestore.instance.collection('user').doc(elderlyId);

    await ref.update({
      'medication': FieldValue.arrayUnion([medicationId])
    }).catchError((e, stackTrace) {
      return e;
    });

    return true;
  }

  static deleteElderlyMedication(String elderlyId, String medicationId) async {
    DocumentReference ref;

    ref = FirebaseFirestore.instance.collection('user').doc(elderlyId);

    await ref.update({
      'medication': FieldValue.arrayRemove([medicationId])
    }).catchError((e, stackTrace) {
      return e;
    });

    return true;
  }

  static editElderlyMealTimings(
      String elderlyId, List<String> mealTimings) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('user').doc(elderlyId);

    await ref.update({'meal timings': mealTimings}).catchError((e) {
      return e;
    });

    return true;
  }

  static addNewAppointment(String elderlyId, String appointmentId) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('user').doc(elderlyId);

    await ref.update({
      'appointment': FieldValue.arrayUnion([appointmentId])
    }).catchError((e) {
      return e;
    });

    return true;
  }

  static deleteElderlyAppointment(
      String elderlyId, String appointmentId) async {
    DocumentReference ref;

    ref = FirebaseFirestore.instance.collection('user').doc(elderlyId);

    await ref.update({
      'appointment': FieldValue.arrayRemove([appointmentId])
    }).catchError((e, stackTrace) {
      return e;
    });

    return true;
  }

  static void saveCaregiverDetails(Caregiver user, User? googleUser) async {
    DocumentReference ref;
    String userId;

    if (googleUser != null) {
      userId = await getUserId(googleUser.email!.toLowerCase());
    } else {
      userId = await getUserId(user.email!.toLowerCase());
    }

    ref = FirebaseFirestore.instance.collection('user').doc(userId);

    await ref.update({
      'name': user.name,
      'emergency contact': user.emergencyContact,
      'role': 'caregiver',
      'elderly': [],
    });
  }

  static Future<dynamic> addNewElderly(
      String caregiverId, String elderlyEmail, String elderlyPIN) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: elderlyEmail.toLowerCase())
        .where('pin', isEqualTo: int.parse(elderlyPIN))
        .get();

    if (query.docs.isEmpty) {
      return false;
    }

    DocumentReference ref;
    ref = FirebaseFirestore.instance.collection('user').doc(caregiverId);

    await ref.update({
      'elderly': FieldValue.arrayUnion([query.docs.first.id])
    }).catchError((e, stackTrace) {
      return e;
    });

    ref =
        FirebaseFirestore.instance.collection('user').doc(query.docs.first.id);
    await ref.update({
      'caregiver': FieldValue.arrayUnion([caregiverId])
    }).catchError((e, stackTrace) {
      return e;
    });

    return true;
  }

  static deleteElderlyFromCaregiver(
      String elderlyEmail, String caregiverEmail) async {
    String caregiverId = await UserDetails.getUserId(caregiverEmail);

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: elderlyEmail.toLowerCase())
        .get();

    if (query.docs.isEmpty) {
      return false;
    }
    DocumentReference ref;
    ref = FirebaseFirestore.instance.collection('user').doc(caregiverId);

    await ref.update({
      'elderly': FieldValue.arrayRemove([query.docs.first.id.toString()])
    }).catchError((e, stackTrace) {
      return e;
    });

    ref =
        FirebaseFirestore.instance.collection('user').doc(query.docs.first.id);

    await ref.update({
      'caregiver': FieldValue.arrayRemove([caregiverId])
    }).catchError((e, stackTrace) {
      return e;
    });

    return true;
  }

  static Future<String> getUserId(String? email) async {
    QuerySnapshot query;

    query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email!.toLowerCase())
        .get();

    return query.docs.first.id;
  }

  static getUserDetails(String userId) async {
    DocumentSnapshot details =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();

    return details.data();
  }
}
