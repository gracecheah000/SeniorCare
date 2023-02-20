// ignore_for_file: prefer_conditional_assignment, depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:seniorcare/models/health_metrics.dart';
import 'package:seniorcare/services/health_metrics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

Future fetchSteps(HealthFactory healthFactory) async {
  DateTime now = DateTime.now();
  try {
    DateTime yest = DateTime(now.year, now.month, now.day);
    Steps step;

    int? stepOfDay = await healthFactory.getTotalStepsInInterval(yest, now);
    if (stepOfDay == null) {
      stepOfDay = 0;
    }
    step = Steps(value: stepOfDay, dateFrom: yest);
    return step;
  } catch (error) {
    print(error);
    return;
  }
}

Future fetchHeartRateData(HealthFactory healthFactory) async {
  DateTime now = DateTime.now();
  List<HealthDataPoint> healthData = [];

  try {
    DateTime yest = DateTime(now.year, now.month, now.day);
    // fetch heart rate from google fit
    healthData = await healthFactory
        .getHealthDataFromTypes(yest, now, [HealthDataType.HEART_RATE]);

    if (healthData.isNotEmpty) {
      healthData = HealthFactory.removeDuplicates(healthData);
    }

    return healthData;
  } catch (error) {
    print(error);
    return;
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((taskName, inputData) async {
    SharedPreferencesAndroid.registerWith();

    await Firebase.initializeApp();
    HealthFactory healthFactory = HealthFactory();

    Steps steps = await fetchSteps(healthFactory);
    List<HealthDataPoint> heartRateData =
        await fetchHeartRateData(healthFactory);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      await HealthServices.saveSteps(steps, userId!);
      await HealthServices.saveHeartRate(heartRateData, userId);

      return true;
    } catch (err) {
      return false;
    }
  });
}
