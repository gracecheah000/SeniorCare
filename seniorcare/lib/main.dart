// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/services/notification_api.dart';
import 'package:seniorcare/start_screen.dart';
import 'package:flutter_config/flutter_config.dart';

Future _backgroundMessageHandler(RemoteMessage message) async {
  print('background message received');
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that the UI is not rendered until initialization is done
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  NotificationServices.init();
  await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SeniorCare',
        home: StartScreen(title: 'SeniorCare'));
  }
}
