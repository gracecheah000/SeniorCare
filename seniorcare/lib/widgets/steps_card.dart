// ignore_for_file: prefer_conditional_assignment

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/models/health_metrics.dart';
import 'package:fl_chart/fl_chart.dart';

class StepsHealthCard extends StatefulWidget {
  const StepsHealthCard({super.key, required this.elderlyId});

  final String elderlyId;

  @override
  State<StepsHealthCard> createState() => _StepsHealthCardState();
}

class _StepsHealthCardState extends State<StepsHealthCard> {
  DateTime now = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  List<Steps> convertToStepObject(Map steps) {
    List<Steps> stepList = [];

    steps.forEach((key, value) {
      stepList.add(Steps(dateFrom: DateTime.parse(key), value: value));
    });

    return stepList;
  }

  List<BarChartGroupData> _stepsChart(List<Steps> stepList) {
    stepList = stepList
        .where((element) =>
            element.dateFrom!.isAfter(startDate!) &&
            element.dateFrom!.isBefore(endDate!))
        .toList()
        .reversed
        .toList();

    return stepList.map((data) {
      Color color;

      if (data.value < Constants.badNoOfSteps) {
        color = Colors.red;
      } else if (data.value < Constants.avgNoOfSteps) {
        color = Colors.yellow;
      } else {
        color = Colors.green;
      }

      return BarChartGroupData(
          x: data.dateFrom!.weekday,
          barRods: [BarChartRodData(toY: data.value.toDouble(), color: color)],
          showingTooltipIndicators: [0]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (startDate == null && endDate == null) {
      setState(() {
        startDate = now.subtract(Duration(days: now.weekday));
        endDate = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
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
          } else if (snapshot.data!.get('steps') == {}) {
            return const Center(
                child: Text('There is no steps synced yet',
                    style: TextStyle(color: Colors.white)));
          } else {
            List<Steps> stepList =
                convertToStepObject(snapshot.data!.get('steps'));
            return AspectRatio(
                aspectRatio: 1,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Daily Steps',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        startDate = startDate!
                                            .subtract(const Duration(days: 7));
                                        endDate = endDate!
                                            .subtract(const Duration(days: 7));
                                      });
                                    },
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 15,
                                        color: Colors.white),
                                    splashRadius: 10),
                                Text(
                                    '${DateFormat.yMMMd().format(startDate!).toString()} - ${DateFormat.yMMMd().format(endDate!).toString()}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        startDate = startDate!
                                            .add(const Duration(days: 7));
                                        endDate = endDate!
                                            .add(const Duration(days: 7));
                                      });
                                    },
                                    icon: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15,
                                        color: Colors.white),
                                    splashRadius: 10)
                              ]),
                          const SizedBox(height: 40),
                          Expanded(
                              child: BarChart(BarChartData(
                                  barTouchData: barTouchData,
                                  barGroups: _stepsChart(stepList),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      bottomTitles:
                                          AxisTitles(sideTitles: _bottomTitles),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false))))))
                        ])));
          }
        });
  }

  BarTouchData get barTouchData => BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(rod.toY.round().toString(),
                const TextStyle(color: Colors.white));
          }));

  SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 1:
            text = 'Mon';
            break;
          case 2:
            text = 'Tue';
            break;
          case 3:
            text = 'Wed';
            break;
          case 4:
            text = 'Thu';
            break;
          case 5:
            text = 'Fri';
            break;
          case 6:
            text = 'Sat';
            break;
          case 7:
            text = 'Sun';
            break;
        }

        return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)));
      });
}
