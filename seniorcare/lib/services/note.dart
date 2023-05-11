import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seniorcare/models/note.dart';
import 'package:seniorcare/services/user_details.dart';

class NoteServices {
  static createNewNote(
      String? appointmentId, Note newNote, String elderlyId) async {
    String noteId = '';

    await FirebaseFirestore.instance.collection('note').add({
      'name': newNote.noteTitle,
      'content': newNote.noteContent,
      'appointment': appointmentId,
      'tag': newNote.noteTag
    }).then((success) {
      noteId = success.id;
    }).catchError((e) {
      return e;
    });

    var result = await UserDetails.addNewNoteToElderly(elderlyId, noteId);

    if (result == true) {
      return true;
    } else {
      return result;
    }
  }

  static getNote(String noteId) async {
    DocumentSnapshot details =
        await FirebaseFirestore.instance.collection('note').doc(noteId).get();

    return details.data();
  }

  static updateNote(Note newNote) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('note').doc(newNote.id);

    await ref.update({
      'name': newNote.noteTitle,
      'content': newNote.noteContent,
      'appointment': newNote.appointmentId,
      'tag': newNote.noteTag
    }).catchError((e) {
      return e;
    });

    return true;
  }
}
