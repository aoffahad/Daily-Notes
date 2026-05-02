import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../controller/note_controller.dart';
import '../widget/note_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final controller = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text("Notes"),
      ),

      body: Obx(() {
        if (controller.notes.isEmpty) {
          return const Center(
            child: Text("No notes yet", style: TextStyle(color: Colors.white)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notes.length,
          itemBuilder: (context, index) {
            final note = controller.notes[index];

            return Dismissible(
              key: Key(note.id),
              direction: DismissDirection.startToEnd,

              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),

              confirmDismiss: (direction) async {
                controller.deleteNote(note.id);

                Get.snackbar(
                  "Deleted",
                  "Note removed",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black,
                  colorText: Colors.white,
                );

                return true;
              },

              child: GestureDetector(
                onTap: () {
                  context.go('/note-details/${note.id}');
                },
                child: NoteCard(note: note),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2F80ED),
        onPressed: () {
        context.push('/add-note');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
