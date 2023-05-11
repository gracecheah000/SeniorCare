import 'package:flutter/material.dart';

class NoteContent extends StatelessWidget {
  final TextEditingController textFieldController;

  const NoteContent({required this.textFieldController, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextField(
            controller: textFieldController,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: null,
            style: const TextStyle(fontSize: 15, height: 1.5)));
  }
}
