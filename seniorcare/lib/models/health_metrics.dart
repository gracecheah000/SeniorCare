import 'package:health/health.dart';

class Steps {
  int value;
  DateTime dateFrom;
  DateTime dateTo;

  Steps({required this.value, required this.dateFrom, required this.dateTo});
}

class HeartRate {
  HealthValue value;
  DateTime dateFrom;
  DateTime dateTo;

  HeartRate(
      {required this.value, required this.dateFrom, required this.dateTo});
}
