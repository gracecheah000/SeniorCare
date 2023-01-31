import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/start_screen.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that the UI is not rendered until initialization is done
  await FlutterConfig.loadEnvVariables();
  // Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     switch (task) {

//     }
//     return Future.value(true);
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeniorCare',
      home: StartScreen(title: 'SeniorCare'),
    );
  }
}
