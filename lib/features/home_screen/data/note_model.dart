

class NoteModel {
  final String id;
  final String userId; 
  final String title;
  final String description;
  final int colorIndex;

  NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.colorIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'colorIndex': colorIndex,
    };
  }

  factory NoteModel.fromMap(String id, Map<String, dynamic> map) {
    return NoteModel(
      id: id,
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      colorIndex: map['colorIndex'],
    );
  }
}