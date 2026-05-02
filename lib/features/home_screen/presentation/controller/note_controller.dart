import 'package:get/get.dart';

import '../../../auth/presentation/controller/auth_controller.dart';
import '../../data/firestore_service.dart';
import '../../data/note_model.dart';

class NotesController extends GetxController {
  final FirestoreService _service = FirestoreService();
  final AuthController _auth = Get.find<AuthController>();

  var notes = <NoteModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  void loadNotes() {
    final userId = _auth.userId;

    if (userId == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    _service.getNotes(userId).listen(
      (data) {
        notes.value = data;
      },
      onError: (e) {
        Get.snackbar(
          "Error",
          "Failed to load notes",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  // ✅ Add Note
  Future<void> addNote(String title, String desc) async {
    try {
      isLoading.value = true;

      final userId = _auth.userId;

      if (userId == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final note = NoteModel(
        id: '',
        userId: userId, // 🔐 REQUIRED for security rules
        title: title,
        description: desc,
        colorIndex: DateTime.now().millisecond % 5,
      );

      await _service.addNote(note);

      Get.snackbar(
        "Success",
        "Note added",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add note",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Update Note
  Future<void> updateNote(String id, String title, String desc) async {
    try {
      isLoading.value = true;

      final userId = _auth.userId;

      if (userId == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final note = NoteModel(
        id: id,
        userId: userId, // 🔐 MUST match Firestore rule
        title: title,
        description: desc,
        colorIndex: DateTime.now().millisecond % 5,
      );

      await _service.updateNote(note);

      Get.snackbar(
        "Success",
        "Note updated",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update note",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Delete Note
  Future<void> deleteNote(String id) async {
    try {
      await _service.deleteNote(id);

      Get.snackbar(
        "Deleted",
        "Note removed",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete note",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}