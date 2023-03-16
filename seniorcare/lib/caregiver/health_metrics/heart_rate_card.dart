import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seniorcare/models/health_metrics.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeartRateCard extends StatefulWidget {
  const HeartRateCard({super.key, required this.elderlyId});

  final String elderlyId;

  @override
  State<HeartRateCard> createState() => _HeartRateCardState();
}

class _HeartRateCardState extends State<HeartRateCard> {
  DateTime now = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  List<HeartRate> convertToHeartRateObject(Map heartRate) {
    List<HeartRate> heartRateList = [];

    heartRate.forEach((key, value) {
      heartRateList.add(HeartRate(
          dateFrom: DateTime.parse(key),
          value: double.parse(value.toString())));
    });

    return heartRateList;
  }

  List<HeartRate> _heartRateChart(List<HeartRate> heartRateList) {
    heartRateList = heartRateList
        .where(((element) =>
            (element.dateFrom.isAfter(startDate!) ||
                element.dateFrom.isAtSameMomentAs(startDate!)) &&
            element.dateFrom.isBefore(endDate!)))
        .toList();

    heartRateList.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    return heartRateList;
  }

  @override
  Widget build(BuildContext context) {
    if (startDate == null) {
      setState(() {
        startDate = DateTime(now.year, now.month, now.day);
        endDate =
            DateTime(now.year, now.month, now.add(const Duration(days: 1)).day);
      });
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('healthData')
            .doc(widget.elderlyId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.data!.get('heart rate') == {}) {
            return const Center(
                child: Text('There is no heart rate synced yet',
                    style: TextStyle(color: Colors.white)));
          } else {
            List<HeartRate> heartRateList =
                convertToHeartRateObject(snapshot.data!.get('heart rate'));

            return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  const Text('Daily Heart Rate',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                startDate = startDate!
                                    .subtract(const Duration(days: 1));
                                endDate =
                                    endDate!.subtract(const Duration(days: 1));
                              });
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                size: 15, color: Colors.white),
                            splashRadius: 10),
                        Text(DateFormat.yMMMd().format(startDate!).toString(),
                            style: const TextStyle(color: Colors.white)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                startDate =
                                    startDate!.add(const Duration(days: 1));
                                endDate = endDate!.add(const Duration(days: 1));
                              });
                            },
                            icon: const Icon(Icons.arrow_forward_ios_rounded,
                                size: 15, color: Colors.white),
                            splashRadius: 10)
                      ]),
                  const SizedBox(height: 10),
                  AspectRatio(
                      aspectRatio: 1,
                      child: SfCartesianChart(
                          trackballBehavior: TrackballBehavior(
                              enable: true,
                              markerSettings: const TrackballMarkerSettings(
                                  markerVisibility:
                                      TrackballVisibilityMode.visible),
                              tooltipSettings: const InteractiveTooltip(
                                  enable: true,
                                  color: Colors.black,
                                  format: 'point.x : point.ybpm')),
                          primaryXAxis: DateTimeAxis(
                              labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              axisBorderType:
                                  AxisBorderType.withoutTopAndBottom,
                              minimum: DateTime(startDate!.year,
                                  startDate!.month, startDate!.day),
                              majorGridLines: const MajorGridLines(width: 0),
                              intervalType: DateTimeIntervalType.minutes,
                              labelIntersectAction:
                                  AxisLabelIntersectAction.hide),
                          primaryYAxis: NumericAxis(
                              labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              decimalPlaces: 0,
                              minimum: 30,
                              interval: 20,
                              majorGridLines: const MajorGridLines(width: 0),
                              plotBands: [
                                PlotBand(
                                    isVisible: true,
                                    start: 60,
                                    end: 100,
                                    shouldRenderAboveSeries: false,
                                    color: const Color.fromARGB(
                                        153, 117, 128, 117))
                              ]),
                          series: <ChartSeries<HeartRate, DateTime>>[
                            FastLineSeries<HeartRate, DateTime>(
                                width: 0.5,
                                color: const Color.fromARGB(255, 255, 57, 43),
                                dataSource: _heartRateChart(heartRateList),
                                xValueMapper: (HeartRate heartRate, _) =>
                                    heartRate.dateFrom,
                                yValueMapper: (HeartRate heartRate, _) =>
                                    heartRate.value == 0
                                        ? null
                                        : heartRate.value,
                                enableTooltip: true)
                          ]))
                ]));
          }
        });
  }
}
