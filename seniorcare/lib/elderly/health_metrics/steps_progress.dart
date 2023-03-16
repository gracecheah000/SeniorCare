import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/services/server_api.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StepsProgress extends StatefulWidget {
  const StepsProgress({super.key, required this.userId});

  final String userId;

  @override
  State<StepsProgress> createState() => _StepsProgressState();
}

class _StepsProgressState extends State<StepsProgress> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120,
        width: 120,
        child: FutureBuilder(
            future: ServerApi.getDailySteps(widget.userId,
                DateFormat('yyyy-MM-dd 00:00:00.000').format(DateTime.now())),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(
                      minimum: 0,
                      maximum: Constants.avgNoOfSteps.toDouble(),
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor))
                ]);
              } else {
                double steps;
                if (snapshot.data != null) {
                  steps = double.parse(snapshot.data!);
                } else {
                  steps = 0;
                }

                Color color;
                if (steps < Constants.badNoOfSteps) {
                  color = const Color.fromARGB(255, 192, 49, 38);
                } else if (steps < Constants.avgNoOfSteps) {
                  color = Colors.yellow;
                } else {
                  color = const Color.fromARGB(255, 79, 236, 85);
                }
                return SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(
                      startAngle: 270,
                      endAngle: 270,
                      minimum: 0,
                      maximum: Constants.avgNoOfSteps.toDouble(),
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: const AxisLineStyle(
                          thickness: 0.13,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor),
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: steps,
                            cornerStyle:
                                (steps > Constants.avgNoOfSteps.toDouble())
                                    ? CornerStyle.bothFlat
                                    : CornerStyle.bothCurve,
                            width: 0.13,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: color),
                        MarkerPointer(
                            value: (steps > Constants.avgNoOfSteps.toDouble())
                                ? steps - Constants.avgNoOfSteps.toDouble()
                                : steps,
                            markerType: MarkerType.circle,
                            color: color,
                            markerHeight: 18,
                            markerWidth: 18)
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            angle: 90,
                            widget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Steps',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  Text(
                                      '${snapshot.data!} / ${Constants.avgNoOfSteps}',
                                      style: TextStyle(color: color))
                                ]))
                      ])
                ]);
              }
            }));
  }
}
