import 'package:flutter/material.dart';

Widget customTextField(
    {String? hint, required TextEditingController controller, Color? color}) {
  Color textColor =
      (color == null ? const Color.fromRGBO(108, 99, 255, 1) : color);

  return TextField(
    controller: controller,
    textCapitalization: TextCapitalization.words,
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
