import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seniorcare/models/health_metrics.dart';

class HealthServices {
  static saveSteps(Steps step, String userId) async {
    await FirebaseFirestore.instance.collection('healthData').doc(userId).set({
      'steps': {step.dateFrom.toString(): step.value}
    }, SetOptions(merge: true)).catchError((e) {
      return e;
    });
  }

  static saveHeartRate(HeartRate heartRate, String userId) async {
    await FirebaseFirestore.instance.collection('healthData').doc(userId).set({
      'heartRate': {heartRate.dateFrom.toString(): heartRate.value}
    }, SetOptions(merge: true)).catchError((e) {
      return e;
    });
  }
}
