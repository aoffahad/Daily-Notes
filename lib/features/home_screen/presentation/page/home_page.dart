import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../controller/note_controller.dart';
import '../widget/note_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NotesController controller = Get.find<NotesController>();
  final AuthController authController = Get.find<AuthController>();

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 HEADER
            _buildHeader(context),

            /// 🔹 SEARCH BAR
            _buildSearchBar(),

            /// 🔹 LIST
            Expanded(
              child: Obx(() {
                if (controller.notes.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    controller.loadNotes();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.notes.length,
                    itemBuilder: (context, index) {
                      final note = controller.notes[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Dismissible(
                          key: Key(note.id.isNotEmpty
                              ? note.id
                              : UniqueKey().toString()),

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
                            await controller.deleteNote(note.id);
                            return true;
                          },

                          child: GestureDetector(
                            onTap: () {
                              context.go('/note-details/${note.id}');
                            },
                            child: NoteCard(note: note),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      /// 🔹 FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2F80ED),
        onPressed: () => context.push('/add-note'),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 🔥 HEADER
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "My Notes",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Keep your thoughts organized",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          /// Logout
          IconButton(
            onPressed: () async {
              controller.clearOnLogout();
              await authController.logout();
              context.go('/');
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          )
        ],
      ),
    );
  }

  /// 🔥 SEARCH BAR (UI only for now)
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search notes...",
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: Icon(Icons.search, color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  ///  EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Icon(Icons.note_alt_outlined,
              size: 80, color: Colors.black),
          SizedBox(height: 10),
          Text(
            "No notes yet",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Tap + to create your first note",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}