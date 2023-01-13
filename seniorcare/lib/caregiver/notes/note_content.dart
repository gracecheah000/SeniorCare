import 'package:flutter/material.dart';

class NoteContent extends StatelessWidget {
  final TextEditingController textFieldController;

  NoteContent({required this.textFieldController});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextField(
            controller: textFieldController,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: null,
            style: const TextStyle(fontSize: 19, height: 1.5)));
  }
}
