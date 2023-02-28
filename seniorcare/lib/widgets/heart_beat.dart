import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/services/server_api.dart';

class HeartBeat extends StatefulWidget {
  const HeartBeat({super.key, required this.userId});

  final String userId;

  @override
  State<HeartBeat> createState() => _HeartBeatState();
}

class _HeartBeatState extends State<HeartBeat> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120,
        width: 120,
        child: FutureBuilder(
            future: ServerApi.getAverageDailyHeartRate(
                widget.userId, DateFormat('yyyy-MM-dd').format(DateTime.now())),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                double avgHeartRate = double.parse(snapshot.data!);
                Color? color;
                if (avgHeartRate < Constants.lowHeartRate ||
                    avgHeartRate > Constants.highHeartRate) {
                  color = const Color.fromARGB(255, 192, 49, 38);
                } else {
                  color = const Color.fromARGB(255, 55, 163, 59);
                }

                return Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 10),
                        color: Colors.white),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/heart.png', scale: 30),
                          Text(avgHeartRate.toInt().toString(),
                              style: const TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.bold)),
                          const Text('bpm')
                        ]));
              }
            }));
  }
}
