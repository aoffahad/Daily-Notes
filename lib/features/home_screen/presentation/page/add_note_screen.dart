import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../data/note_model.dart';
import '../controller/note_controller.dart';

class AddNotePage extends StatelessWidget {
  AddNotePage({super.key, this.note});

  final NoteModel? note;

  final titleController = TextEditingController();
  final descController = TextEditingController();

  final controller = Get.find<NotesController>();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      titleController.text = note!.title;
      descController.text = note!.description;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? "Add Note" : "Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 6,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                
                onPressed: () => _save(context),
                child: Text(note == null ? "Save" : "Update"),
              ),
            )
          ],
        ),
      ),
    );
  }

void _save(BuildContext context) {
  final title = titleController.text.trim();
  final desc = descController.text.trim();

  if (title.isEmpty || desc.isEmpty) {
    Get.snackbar(
      "Error",
      "Title & Description required",
      snackPosition: SnackPosition.TOP,
    );
    return;
  }

  if (note == null) {
    controller.addNote(title, desc);
  } else {
    controller.updateNote(note!.id, title, desc);
  }

  context.go('/home-page'); 
}
}