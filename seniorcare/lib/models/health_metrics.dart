import 'package:health/health.dart';

class Steps {
  int value;
  DateTime? dateFrom;

  Steps({required this.value, this.dateFrom});
}

class HeartRate {
  HealthValue value;
  DateTime dateFrom;
  DateTime dateTo;

  HeartRate(
      {required this.value, required this.dateFrom, required this.dateTo});
}
