import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../controller/note_controller.dart';

class NoteDetailsPage extends StatelessWidget {
  const NoteDetailsPage({super.key, required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotesController>();

    final note = controller.notes.firstWhere((n) => n.id == noteId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.go('/add-note/${note.id}');
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  note.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    note.description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1.5,
                      
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
