import 'package:flutter/material.dart';
import 'package:seniorcare/caregiver/notes/note_content.dart';
import 'package:seniorcare/models/note.dart';
import 'package:seniorcare/services/note.dart';

import '../../widgets/appbar.dart';
import 'note_title.dart';

class NoteEdit extends StatefulWidget {
  const NoteEdit(
      {super.key,
      this.tag,
      this.title,
      this.appointmentId,
      required this.elderlyId,
      this.existingNote,
      this.updateParent});

  final String? tag;
  final String? title;
  final String? appointmentId;
  final String elderlyId;
  final Note? existingNote;
  final Function? updateParent;

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  String noteTitle = '';
  String noteContent = '';
  bool _beforeEdit = true;

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title != null) {
      _titleTextController.text = widget.title!;
    }
    if (widget.existingNote != null && _beforeEdit == true) {
      _titleTextController.text = widget.existingNote!.noteTitle;
      _contentTextController.text = widget.existingNote!.noteContent;
    }

    setState(() {
      _beforeEdit = false;
    });

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SeniorCareAppBar(start: false),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
            Widget>[
          NoteTitle(
            textFieldController: _titleTextController,
          ),
          Padding(
              padding: EdgeInsets.only(
                  right: size.width * 0.07, top: size.height * 0.02),
              child: (widget.tag != null)
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromRGBO(108, 99, 255, 1)),
                          borderRadius: BorderRadius.circular(25)),
                      width: size.width * 0.3,
                      height: size.height * 0.07,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Appointment',
                                style: TextStyle(
                                    color: Color.fromRGBO(108, 99, 255, 1),
                                    fontWeight: FontWeight.bold)),
                            Text(widget.tag.toString(),
                                style: const TextStyle(
                                    color: Color.fromRGBO(108, 99, 255, 1)))
                          ]))
                  : (widget.existingNote != null)
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromRGBO(108, 99, 255, 1)),
                              borderRadius: BorderRadius.circular(25)),
                          width: size.width * 0.3,
                          height: size.height * 0.07,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Appointment',
                                    style: TextStyle(
                                        color: Color.fromRGBO(108, 99, 255, 1),
                                        fontWeight: FontWeight.bold)),
                                Text(widget.existingNote!.noteTag.toString(),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(108, 99, 255, 1)))
                              ]))
                      : Container())
        ]),
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.03, horizontal: size.width * 0.07),
            child: SingleChildScrollView(
                child: Container(
                    height: size.height * 0.66,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(108, 99, 255, 1)),
                        borderRadius: BorderRadius.circular(10)),
                    child: NoteContent(
                        textFieldController: _contentTextController))))
      ])),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (_titleTextController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Please fill up the title of the note'),
                  duration: Duration(seconds: 2)));
            } else if (_contentTextController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Please fill up the content of the note'),
                  duration: Duration(seconds: 2)));
            } else if (widget.existingNote != null) {
              Note newNote = Note(
                  id: widget.existingNote!.id,
                  noteTitle: _titleTextController.text,
                  noteContent: _contentTextController.text,
                  noteTag: widget.existingNote!.noteTag,
                  appointmentId: widget.existingNote!.appointmentId);
              try {
                await NoteServices.updateNote(newNote);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'There is an error saving the note. Please try again'),
                    duration: Duration(seconds: 2)));
              } finally {
                Navigator.pop(context);
              }
              widget.updateParent!();
            } else {
              Note newNote;
              if (widget.tag != null) {
                newNote = Note(
                    noteTitle: _titleTextController.text,
                    noteContent: _contentTextController.text,
                    noteTag: widget.tag!);
              } else {
                newNote = Note(
                    noteTitle: _titleTextController.text,
                    noteContent: _contentTextController.text);
              }
              try {
                await NoteServices.createNewNote(
                    widget.appointmentId, newNote, widget.elderlyId);
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'There is an error saving the note. Please try again'),
                    duration: Duration(seconds: 2)));
              } finally {
                setState(() {
                  _beforeEdit = true;
                });
                Navigator.pop(context);
              }
            }
            return;
          },
          label: const Text('Add'),
          backgroundColor: const Color.fromRGBO(108, 99, 255, 1)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
