import 'package:flutter/material.dart';

class Constants {
  static const String deployedURL =
      "https://seniorcare-377202.as.r.appspot.com";
  static const String medNotificationTitle = "Time to eat your medication!";
  static const String medNotificationBody =
      "You have medications to take! Click to view.";

  static const String apptNotificationTitle = "You have an appointment soon";
  static const String apptNotificationBody =
      "You have an appointment in 15 minutes";

  static const int morningNotificationId = 0;
  static const int afternoonNotificationId = 1;
  static const int nightNotificationId = 2;

  static const List<DropdownMenuItem<String>> completeMenuItems = [
    DropdownMenuItem(value: 'To Complete', child: Text('To Complete')),
    DropdownMenuItem(
        value: 'Stop Upon Recovery', child: Text('Stop upon recovery'))
  ];

  static const List<DropdownMenuItem<String>> frequencyMenuItems = [
    DropdownMenuItem(value: 'Every morning', child: Text('Every morning')),
    DropdownMenuItem(value: 'Every night', child: Text('Every night')),
    DropdownMenuItem(value: 'Twice a day', child: Text('Twice a day')),
    DropdownMenuItem(value: '3 times a day', child: Text('3 times a day'))
  ];

  static const List<DropdownMenuItem<String>> timingMenuItems = [
    DropdownMenuItem(value: 'Before meals', child: Text('Before meals')),
    DropdownMenuItem(value: 'With meals', child: Text('With meals')),
    DropdownMenuItem(value: 'After meals', child: Text('After meals'))
  ];

  static const List<DropdownMenuItem<String>> roleMenuItems = [
    DropdownMenuItem(value: 'Elderly', child: Text('Elderly')),
    DropdownMenuItem(value: 'Caregiver', child: Text('Caregiver'))
  ];

  static const List<DropdownMenuItem<String>> sexMenuItems = [
    DropdownMenuItem(value: 'Male', child: Text('Male')),
    DropdownMenuItem(value: 'Female', child: Text('Female'))
  ];

  static const List<String> healthRisksDatabase = [
    'Diabetes',
    'High Blood Cholesterol'
  ];

  static const int badNoOfSteps = 3000;
  static const int avgNoOfSteps = 7500;
  static const int lowHeartRate = 60;
  static const int highHeartRate = 100;

  static const String googleFitDownloadTitle = "Download Google Fit";
  static const String googleFitDownloadContent =
      'Download Google Fit from the Google Play Store';

  static const String googleFitPermissionTitle = 'Authorize Google Fit';
  static const String googleFitPermissionContent =
      'Authorize Google Fit to access your health data.\n\nOnce authorized, data from Google Fit will be synced to Seniorcare for viewing.';

  static const String fitbitDownloadTitle =
      "Download Fitbit and FitToFit (optional)";
  static const String fitbitDownloadContent =
      "Download Fitbit from the Google Play Store. \n\nTo sync your Fitbit data with Google Fit, install FitToFit from the Google Play Store.\n\nOnce setup, enable Autosync in FitToFit's settings.";
}
