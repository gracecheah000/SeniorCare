import 'package:flutter/material.dart';
import 'package:seniorcare/caregiver/notes/note_content.dart';

import '../../widgets/appbar.dart';
import 'note_title.dart';

class NoteEdit extends StatefulWidget {
  const NoteEdit({super.key, this.tag, this.title});
  final DateTime? tag;
  final String? title;

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  String noteTitle = '';
  String noteContent = '';

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();

  void handleTitleTextChange() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void handleContentChange() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  @override
  void initState() {
    super.initState();
    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleContentChange);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SeniorCareAppBar(start: false),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  NoteTitle(
                    textFieldController: _titleTextController,
                  ),
                  (widget.tag == null)
                      ? Container(
                          width: size.width * 0.1,
                        )
                      : Container()
                ],
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: SingleChildScrollView(
                      child: Container(
                          height: 540,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromRGBO(108, 99, 255, 1)),
                              borderRadius: BorderRadius.circular(10)),
                          child: NoteContent(
                              textFieldController: _contentTextController))))
            ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: to save notes in backend
          Navigator.pop(context);
          return;
        },
        label: Text('Add'),
        backgroundColor: Color.fromRGBO(108, 99, 255, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
