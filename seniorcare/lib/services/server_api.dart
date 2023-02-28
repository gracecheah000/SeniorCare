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
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/medication/$registrationToken'),
        headers: headers,
        body: json.encode(request));
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

    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/medication/delete/$registrationToken'),
        headers: headers,
        body: json.encode(request));
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
      'scheduledDateTime': appointment.eventDateTime.toString(),
      'appointmentId': appointmentId
    };
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/appointment/$registrationToken'),
        headers: headers,
        body: json.encode(request));
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
      'notificationId': appointment.notificationId.toString()
    };

    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
        Uri.parse(
            '${Constants.deployedURL}/notification/appointment/delete/$registrationToken'),
        headers: headers,
        body: json.encode(request));

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
}
