// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_conditional_assignment

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/caregiver/notes/notes_edit.dart';
import 'package:seniorcare/models/note.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/note.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';

class Notepad extends StatefulWidget {
  const Notepad({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<Notepad> createState() => _NotepadState();
}

class _NotepadState extends State<Notepad> {
  Elderly? selectedElderly;
  int elderlyIndex = 0;

  @override
  Widget build(BuildContext context) {
    Future<dynamic> caregiverElderlyList = getElderlyList();
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: FutureBuilder(
            future: caregiverElderlyList,
            builder: (((context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data.isEmpty) {
                return const Center(
                    child: Text('No elderly has been added',
                        style: TextStyle(fontWeight: FontWeight.bold)));
              } else {
                List<Elderly> elderlyList = snapshot.data;
                if (selectedElderly == null) {
                  selectedElderly = elderlyList[0];
                }
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                          height: size.height * 0.07,
                          width: size.width * 0.5,
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(108, 99, 255, 1),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: DropdownButton<Elderly>(
                                  isExpanded: true,
                                  value: selectedElderly,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(108, 99, 255, 1),
                                      fontFamily: 'Montserrat',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                  onChanged: (Elderly? value) {
                                    setState(() {
                                      selectedElderly = value;
                                      elderlyIndex = elderlyList
                                          .indexOf(selectedElderly as Elderly);
                                    });
                                  },
                                  items: elderlyList.map((Elderly elderly) {
                                    return DropdownMenuItem<Elderly>(
                                        value: elderly,
                                        child: Text(elderly.name
                                            .toString()
                                            .toUpperCase()));
                                  }).toList(),
                                  underline: Container(),
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color:
                                          Color.fromRGBO(108, 99, 255, 1))))),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user')
                              .doc(selectedElderly!.id)
                              .snapshots(),
                          builder: (((context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox(
                                  height: size.height * 0.7,
                                  child: const CircularProgressIndicator(
                                    color: Color.fromARGB(255, 29, 77, 145),
                                  ));
                            } else {
                              List notesIdList =
                                  snapshot.data!.data()!['notes'];

                              Future<dynamic> notes =
                                  getElderlyNotes(notesIdList);

                              return FutureBuilder(
                                  future: notes,
                                  builder: (((context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                              color: Color.fromARGB(
                                                  255, 29, 77, 145)));
                                    } else {
                                      List<Note> notes = snapshot.data;
                                      return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.height * 0.03,
                                              horizontal: size.width * 0.05),
                                          child: Container(
                                              height: size.height * 0.7,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 29, 77, 145),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: notes.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                        padding: EdgeInsets.only(
                                                            left: size.width *
                                                                0.01,
                                                            right: size.width *
                                                                0.01,
                                                            top: size.height *
                                                                0.005),
                                                        child: ListTile(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => NoteEdit(
                                                                          existingNote: notes[
                                                                              index],
                                                                          elderlyId: selectedElderly!
                                                                              .id
                                                                              .toString(),
                                                                          updateParent:
                                                                              reloadBuilder)));
                                                            },
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        15),
                                                                side: BorderSide(
                                                                    color: Color.fromARGB(
                                                                        255,
                                                                        104,
                                                                        114,
                                                                        158))),
                                                            title: Text(notes[index].noteTitle,
                                                                style: TextStyle(
                                                                    color: Color.fromARGB(255, 29, 77, 145),
                                                                    fontWeight: FontWeight.bold)),
                                                            subtitle: notes[index].noteTag != null
                                                                ? Row(children: [
                                                                    Text(
                                                                        'Appointment on: ',
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                104,
                                                                                114,
                                                                                158),
                                                                            fontSize:
                                                                                13)),
                                                                    Text(
                                                                        notes[index]
                                                                            .noteTag
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                104,
                                                                                114,
                                                                                158),
                                                                            fontSize:
                                                                                13))
                                                                  ])
                                                                : null));
                                                  })));
                                    }
                                  })));
                            }
                          })))
                    ]);
              }
            }))),
        floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NoteEdit(elderlyId: selectedElderly!.id.toString())));
            },
            backgroundColor: Color.fromARGB(255, 160, 171, 221),
            heroTag: "AddNote",
            child: Image.asset('assets/images/add.png')));
  }

  getElderlyList() async {
    List details = await UserDetails.getUserDetailsWithEmail(widget.userEmail);
    List<dynamic> elderlyList = details[1]['elderly'];

    List<Elderly> elderlyDetails = [];

    for (var element in elderlyList) {
      Map details = await UserDetails.getUserDetailsWithId(element);
      Elderly elderly =
          Elderly(email: details['email'], name: details['name'], id: element);
      elderlyDetails.add(elderly);
    }

    return elderlyDetails;
  }

  getElderlyNotes(List notesIdList) async {
    List<Note> notesList = [];

    if (notesIdList.isNotEmpty) {
      for (String id in notesIdList) {
        Map noteDetails = await NoteServices.getNote(id);
        Note newNote = Note(
            id: id,
            noteTitle: noteDetails['name'],
            noteContent: noteDetails['content'],
            noteTag: noteDetails['tag'],
            appointmentId: noteDetails['appointment']);

        notesList.add(newNote);
      }
    }

    return notesList;
  }

  reloadBuilder() {
    setState(() {});
  }
}
