import 'package:flutter/material.dart';

class NoteTitle extends StatelessWidget {
  final TextEditingController textFieldController;

  const NoteTitle({required this.textFieldController, super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.07, top: size.height * 0.02),
        child: Container(
            width: size.width * 0.5,
            height: size.height * 0.07,
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromRGBO(108, 99, 255, 1), width: 2),
                borderRadius: BorderRadius.circular(25)),
            child: TextField(
              controller: textFieldController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  counter: null,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(108, 99, 255, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              style: const TextStyle(
                  color: Color.fromRGBO(108, 99, 255, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textCapitalization: TextCapitalization.words,
            )));
  }
}
