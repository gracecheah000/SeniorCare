import 'package:flutter/material.dart';

class SeniorCareAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SeniorCareAppBar({super.key, required this.start, this.profile});

  final bool start;
  final bool? profile;

  @override
  Widget build(BuildContext context) {
    if (!start) {
      return AppBar(
        backgroundColor: determineColour(profile),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 20),
        title: Row(
          children: const <Widget>[
            Text('Senior',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat')),
            Text('Care',
                style: TextStyle(
                    color: Color.fromRGBO(180, 107, 237, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'))
          ],
        ),
        elevation: 0,
      );
    } else {
      return AppBar(
        title: Row(
          children: const <Widget>[
            Text('Senior',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat')),
            Text('Care',
                style: TextStyle(
                    color: Color.fromRGBO(180, 107, 237, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'))
          ],
        ),
        backgroundColor: Colors.white, //Color.fromARGB(255, 207, 207, 207),
        elevation: 0,
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
  determineColour(bool? profile) {
    if (profile == null) {
      return Colors.white;
    } else {
      return const Color.fromARGB(255, 176, 200, 233);
    }
  }
}
