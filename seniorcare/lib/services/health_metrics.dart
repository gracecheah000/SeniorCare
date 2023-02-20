import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health/health.dart';
import 'package:seniorcare/models/health_metrics.dart';

class HealthServices {
  static saveSteps(Steps step, String userId) async {
    await FirebaseFirestore.instance.collection('healthData').doc(userId).set({
      'steps': {step.dateFrom.toString(): step.value}
    }, SetOptions(merge: true)).catchError((e) {
      return e;
    });
  }

  static saveHeartRate(List<HealthDataPoint> heartRate, String userId) async {
    Map heartRateMap = {};
    for (HealthDataPoint h in heartRate) {
      heartRateMap[h.dateFrom.toString()] = double.parse(h.value.toString());
    }

    int length = heartRateMap.length;
    HealthDataPoint h = heartRate[length - 1];
    heartRateMap[h.dateFrom.add(Duration(minutes: 1)).toString()] = 0;

    await FirebaseFirestore.instance.collection('healthData').doc(userId).set(
        {'heart rate': heartRateMap}, SetOptions(merge: true)).catchError((e) {
      return e;
    });
  }
}
