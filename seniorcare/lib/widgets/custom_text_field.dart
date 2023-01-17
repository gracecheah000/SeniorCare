import 'package:flutter/material.dart';

Widget customTextField(
    {String? hint,
    required TextEditingController controller,
    Color? color,
    bool? obscureTextNeeded}) {
  Color textColor =
      (color == null ? const Color.fromRGBO(108, 99, 255, 1) : color);

  bool obscureText = (obscureTextNeeded == null) ? false : true;

  return TextField(
    controller: controller,
    textCapitalization: TextCapitalization.words,
    obscureText: obscureText,
    decoration: InputDecoration(
        labelText: hint ?? '',
        labelStyle: TextStyle(color: textColor),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor),
            borderRadius: BorderRadius.circular(20))),
  );
}
