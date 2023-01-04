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
    });
  }

  static void saveCaregiverDetails(Caregiver user, User? googleUser) async {
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
      'emergency contact': user.emergencyContact,
      'role': 'caregiver'
    });
  }

  static Future<String> getUserId(String? email) async {
    QuerySnapshot query;

    query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    return query.docs.first.id;
  }
}
