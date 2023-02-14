import 'package:flutter/material.dart';
import 'package:seniorcare/widgets/appbar.dart';

class HealthMetric extends StatefulWidget {
  const HealthMetric({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<HealthMetric> createState() => _HealthMetricState();
}

class _HealthMetricState extends State<HealthMetric> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const SeniorCareAppBar(start: false),
        body: const Center(
          child: Text('Health Metric'),
        ));
  }
}
