import 'package:get/get.dart';
import 'dart:math';

import '../../data/note_model.dart';

class NotesController extends GetxController {
  var notes = <NoteModel>[].obs;
  var isLoading = false.obs;

  final random = Random();

  void addNote(String title, String desc) {
    notes.add(
      NoteModel(
        id: DateTime.now().toString(),
        title: title,
        description: desc,
        colorIndex: random.nextInt(5),
      ),
    );
  }

  void updateNote(String id, String title, String desc) {
    final index = notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      notes[index] = NoteModel(
        id: id,
        title: title,
        description: desc,
        colorIndex: notes[index].colorIndex,
      );
    }
  }

  void deleteNote(String id) {
    notes.removeWhere((n) => n.id == id);
  }
}