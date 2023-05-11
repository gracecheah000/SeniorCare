import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorcare/models/health_metrics.dart';
import 'package:seniorcare/models/user.dart';

import 'health_metrics.dart';

class UserDetails {
  static void saveElderlyDetails(Elderly user, User? newUser) async {
    DocumentReference ref;
    String userId;

    userId = await getUserId(newUser!.email!.toLowerCase());

    ref = FirebaseFirestore.instance.collection('user').doc(userId);
    DateTime now = DateTime.now();
    Steps newUserSteps =
        Steps(dateFrom: DateTime(now.year, now.month, now.day), value: 0);

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
      'notes': [],
      'pin': Random().nextInt(999999),
      'meal timings': ['7:00AM', '12:00PM', '7:00PM'],
      'notification': [0, 0, 0],
      'contact': user.contact
    });

    HealthServices.saveSteps(newUserSteps, userId);
    HealthServices.saveHeartRate([], userId, true);
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

  static getNotifications(String userId) async {
    Map details = await getUserDetailsWithId(userId);
    List notification = details['notification'];
    return notification;
  }

  // to track duplicated notifications on elderly device
  static addNumberOfNotifications(
      String userId, List numberOfNotifications) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('user').doc(userId);

    DocumentSnapshot details = await ref.get();

    List list = (details.data() as Map)['notification'];

    for (int i = 0; i < 3; i++) {
      list[i] = list[i] + numberOfNotifications[i];
    }

    await ref.update({'notification': list}).catchError((e) {
      return e;
    });

    return true;
  }

// to track duplicated notifications on elderly device
  static deleteNumberOfNotifications(
      String userId, List numberOfNotifications) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('user').doc(userId);

    DocumentSnapshot details = await ref.get();

    List list = (details.data() as Map)['notification'];

    for (int i = 0; i < 3; i++) {
      list[i] = list[i] - numberOfNotifications[i];
    }

    await ref.update({'notification': list}).catchError((e) {
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

  static addNewNoteToElderly(String elderlyId, String noteId) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('user').doc(elderlyId);

    await ref.update({
      'notes': FieldValue.arrayUnion([noteId])
    }).catchError((e) {
      return e;
    });

    return true;
  }

  static void saveCaregiverDetails(Caregiver user, User? newUser) async {
    DocumentReference ref;
    String userId;

    userId = await getUserId(newUser!.email!.toLowerCase());

    ref = FirebaseFirestore.instance.collection('user').doc(userId);

    await ref.update({
      'name': user.name,
      'emergency contact': user.emergencyContact,
      'role': 'caregiver',
      'elderly': []
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
    DocumentReference ref =
        FirebaseFirestore.instance.collection('user').doc(caregiverId);

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

  static getUserDetailsWithId(String userId) async {
    DocumentSnapshot details =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();

    return details.data();
  }

  static getUserDetailsWithEmail(String userEmail) async {
    String userId = await getUserId(userEmail);
    DocumentSnapshot details =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();

    return [userId, details.data()];
  }

  static void updateMessagingToken(String token, String userEmail) async {
    String userId = await UserDetails.getUserId(userEmail);
    DocumentReference ref =
        FirebaseFirestore.instance.collection('user').doc(userId);

    await ref.update({'deviceToken': token}).catchError((e, stackTrace) {
      return e;
    });
  }
}
