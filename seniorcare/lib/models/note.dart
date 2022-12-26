class Note {
  int id;
  String userId;
  String noteTitle;
  String noteContent;
  String? noteTag;

  Note(
      {required this.id,
      required this.userId,
      required this.noteTitle,
      required this.noteContent,
      this.noteTag});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    if (noteTag != null) {
      data['noteTag'] = noteTag;
    }

    data['id'] = id;
    data['userId'] = userId;
    data['noteTitle'] = noteTitle;
    data['noteContent'] = noteContent;

    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'userId': userId,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      'noteTag': noteTag
    }.toString();
  }
}
