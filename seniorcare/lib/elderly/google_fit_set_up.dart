// ignore_for_file: prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:workmanager/workmanager.dart';

class GoogleFitSetUp extends StatefulWidget {
  const GoogleFitSetUp({super.key});

  @override
  State<GoogleFitSetUp> createState() => _GoogleFitSetUpState();
}

class _GoogleFitSetUpState extends State<GoogleFitSetUp> {
  HealthFactory healthFactory = HealthFactory();
  int _currentStep = 0;

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2
        ? setState(() => _currentStep += 1)
        : Navigator.pop(context);
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Future authorize() async {
    final types = [HealthDataType.HEART_RATE, HealthDataType.STEPS];

    await Permission.activityRecognition.request();

    bool requested = await healthFactory.requestAuthorization(types);

    return requested;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: const SeniorCareAppBar(start: false),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, size.height * 0.02, 0, 0),
              height: size.height * 0.07,
              width: size.width * 0.55,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromRGBO(108, 99, 255, 1),
                          width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: const Center(
                      child: Text("Google Fit Setup",
                          style: TextStyle(
                              color: Color.fromRGBO(108, 99, 255, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          textAlign: TextAlign.center)))),
          Stepper(
              type: StepperType.vertical,
              physics: const ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              elevation: 5,
              steps: <Step>[
                Step(
                    title: const Text(Constants.googleFitDownloadTitle,
                        style: TextStyle(fontSize: 18)),
                    content: const Text(Constants.googleFitDownloadContent,
                        style: TextStyle(
                            color: Color.fromARGB(255, 109, 108, 108),
                            fontSize: 16)),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled),
                Step(
                    title: const Text(Constants.googleFitPermissionTitle,
                        style: TextStyle(fontSize: 18)),
                    content: const Text(Constants.googleFitPermissionContent,
                        style: TextStyle(
                            color: Color.fromARGB(255, 109, 108, 108),
                            fontSize: 16)),
                    isActive: _currentStep >= 1,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled),
                Step(
                    title: const Text(Constants.fitbitDownloadTitle,
                        style: TextStyle(fontSize: 18)),
                    content: const Text(Constants.fitbitDownloadContent,
                        style: TextStyle(
                            color: Color.fromARGB(255, 109, 108, 108),
                            fontSize: 16)),
                    isActive: _currentStep >= 2,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled)
              ],
              controlsBuilder: (context, details) {
                final isLastStep = _currentStep == 2;
                return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(children: <Widget>[
                      if (_currentStep == 0 || _currentStep == 2)
                        Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromRGBO(108, 99, 255, 1))),
                                onPressed: details.onStepContinue,
                                child: Text(isLastStep ? 'DONE' : 'NEXT')))
                      else
                        Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromRGBO(108, 99, 255, 1))),
                                onPressed: () async {
                                  bool authorized = await authorize();
                                  if (authorized) {
                                    await Workmanager().registerPeriodicTask(
                                        "health metrics update",
                                        "health metrics update",
                                        existingWorkPolicy:
                                            ExistingWorkPolicy.replace,
                                        frequency: const Duration(minutes: 5),
                                        backoffPolicy: BackoffPolicy.linear,
                                        backoffPolicyDelay:
                                            const Duration(seconds: 5));

                                    setState(() {
                                      _currentStep += 1;
                                    });
                                  }
                                },
                                child: const Text("AUTHORIZE"))),
                      const SizedBox(width: 12),
                      if (_currentStep != 0)
                        Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromRGBO(
                                            175, 169, 247, 1))),
                                onPressed: details.onStepCancel,
                                child: const Text("BACK")))
                    ]));
              })
        ])));
  }
}
