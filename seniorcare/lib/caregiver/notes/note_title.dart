import 'package:flutter/material.dart';

class NoteTitle extends StatelessWidget {
  final textFieldController;

  NoteTitle({required this.textFieldController});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, top: 10),
        child: Container(
            width: 250,
            height: 50,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(108, 99, 255, 1), width: 2),
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
