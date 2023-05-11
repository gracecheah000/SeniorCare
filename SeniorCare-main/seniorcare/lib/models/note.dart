class Note {
  String? id;
  String noteTitle;
  String noteContent;
  String? noteTag;
  String? appointmentId;

  Note(
      {this.id,
      required this.noteTitle,
      required this.noteContent,
      this.noteTag,
      this.appointmentId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (noteTag != null) {
      data['noteTag'] = noteTag;
    }

    if (appointmentId != null) {
      data['appointmentId'] = appointmentId;
    }

    data['id'] = id;
    data['noteTitle'] = noteTitle;
    data['noteContent'] = noteContent;

    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      'noteTag': noteTag,
      'appointmentId': appointmentId
    }.toString();
  }
}
