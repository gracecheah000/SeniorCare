import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class HealthCard extends StatefulWidget {
  const HealthCard({super.key, required this.dataList, required this.title});

  final List dataList;
  final String title;

  @override
  State<HealthCard> createState() => _HealthCardState();
}

class _HealthCardState extends State<HealthCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            //Initialize the spark charts widget
            child: SfSparkLineChart.custom(
                //Enable the trackball
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                marker: const SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => widget.dataList[index].dateTo.day,
                yValueMapper: (int index) => widget.dataList[index].value,
                dataCount: 5)));
  }
}
