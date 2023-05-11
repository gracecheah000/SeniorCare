// ignore_for_file: prefer_conditional_assignment, depend_on_referenced_packages

import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:seniorcare/models/health_metrics.dart';
import 'package:seniorcare/services/health_metrics.dart';
import 'package:seniorcare/services/server_api.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:geocoding/geocoding.dart';

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

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
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

      Map elderlyDetails = await UserDetails.getUserDetailsWithId(userId!);
      double lat = elderlyDetails['latitude'];
      double long = elderlyDetails['longitude'];

      String address = elderlyDetails['address'];

      List<String> caregiverTokenList = [];

      for (String id in elderlyDetails['caregiver']) {
        Map caregiverDetails = await UserDetails.getUserDetailsWithId(id);
        caregiverTokenList.add(caregiverDetails['deviceToken']);
      }

      List<Location> latlng = await locationFromAddress(address);

      var distance =
          calculateDistance(lat, long, latlng[0].latitude, latlng[0].longitude);

      if (distance > 1) {
        for (String token in caregiverTokenList) {
          ServerApi.sendGeofencingNotification(token, elderlyDetails['name']);
        }
      }

      await HealthServices.saveSteps(steps, userId);
      await HealthServices.saveHeartRate(heartRateData, userId, false);

      return true;
    } catch (err) {
      return false;
    }
  });
}
