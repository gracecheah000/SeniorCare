import 'dart:convert';

import 'package:seniorcare/const.dart';
import 'package:seniorcare/models/appointment.dart';
import 'package:seniorcare/models/medication.dart';
import 'package:http/http.dart' as http;

class ServerApi {
  static void sendAddMedicationPush(
      Medication medication, String registrationToken) async {
    if (medication.medicationName.isEmpty) {
      return;
    }

    Map<String, dynamic> request = {
      "type": "Medication",
      'action': 'add',
      "frequency": medication.medicationFrequency
    };

    Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/medication/$registrationToken'),
        headers: headers,
        body: json.encode(request));

    print(response.body);

    return;
  }

  static void deleteMedicationPush(
      Medication medication, String registrationToken) async {
    if (medication.medicationName.isEmpty) {
      return;
    }

    Map<String, dynamic> request = {
      'type': 'Medication',
      'action': 'delete',
      'frequency': medication.medicationFrequency
    };

    Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/medication/delete/$registrationToken'),
        headers: headers,
        body: json.encode(request));

    print(response.body);

    return;
  }

  static void updateMedicationNotificationPush(String registrationToken) async {
    Map<String, dynamic> request = {'type': 'Medication', 'action': 'update'};

    Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/medication/update/$registrationToken'),
        headers: headers,
        body: json.encode(request));

    print(response.body);

    return;
  }

  static void sendAddAppointmentPush(Appointment appointment,
      String registrationToken, String appointmentId) async {
    if (appointment.eventTitle.isEmpty) {
      return;
    }

    Map<String, dynamic> request = {
      "type": "Appointment",
      'action': 'add',
      'scheduledReminderTime': appointment.reminderTime!.toString(),
      'appointmentId': appointmentId
    };

    Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/appointment/$registrationToken'),
        headers: headers,
        body: json.encode(request));

    print(response.body);
    return;
  }

  static void deleteAppointmentPush(
      Appointment appointment, String registrationToken) async {
    if (appointment.eventTitle.isEmpty) {
      return;
    }

    Map<String, dynamic> request = {
      'type': 'Appointment',
      'action': 'delete',
      'notificationId': appointment.elderlyNotificationId.toString()
    };

    Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/appointment/delete/$registrationToken'),
        headers: headers,
        body: json.encode(request));

    print(response.body);

    return;
  }

  static Future<String> getDailySteps(String userId, String currentDate) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.deployedURL}/health_metrics/step?id=$userId&date=$currentDate'),
    );

    return response.body;
  }

  static Future<String> getAverageDailyHeartRate(
      String userId, String currentDate) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.deployedURL}/health_metrics/heart_rate?id=$userId&date=$currentDate'),
    );
    return response.body;
  }

  static void sendSOSPush(List caregiverDetails, String name) async {
    Map<String, dynamic> request = {'type': 'SOS', 'name': name.toUpperCase()};

    Map<String, String> headers = {'Content-Type': 'application/json'};

    for (var caregiver in caregiverDetails) {
      final response = await http.post(
          Uri.parse(
              '${Constants.deployedURL}/notification/sos/${caregiver.registrationToken}'),
          headers: headers,
          body: json.encode(request));

      print(response.body);
    }
    return;
  }

  static void sendGeofencingNotification(
      String caregiverToken, String name) async {
    Map<String, dynamic> request = {
      'type': 'Geofencing',
      'name': name.toUpperCase()
    };

    Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/geofence/$caregiverToken'),
        headers: headers,
        body: json.encode(request));

    print(response.body);
    return;
  }
}
