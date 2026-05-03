import 'package:get/get.dart';

import '../../../auth/presentation/controller/auth_controller.dart';
import '../../data/firestore_service.dart';
import '../../data/note_model.dart';

class NotesController extends GetxController {
  final FirestoreService _service = FirestoreService();
  final AuthController _auth = Get.find<AuthController>();

  var notes = <NoteModel>[].obs;
  var isLoading = false.obs;

  Stream<List<NoteModel>>? _notesStream;

  @override
  void onInit() {
    super.onInit();

    // ✅ Listen to auth changes
    ever(_auth.user, (user) {
      if (user != null) {
        loadNotes();
      } else {
        notes.clear();
      }
    });
  }

  // ✅ Load notes safely
  void loadNotes() {
    final userId = _auth.userId;

    if (userId == null) return;

    _notesStream?.listen(null)?.cancel(); // cancel old listener

    _notesStream = _service.getNotes(userId);

    _notesStream!.listen(
      (data) {
        notes.value = data;
      },
      onError: (e) {
        Get.snackbar("Error", "Failed to load notes");
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
        userId: userId,
        title: title,
        description: desc,
        colorIndex: DateTime.now().millisecond % 5,
      );

      await _service.addNote(note);

      Get.snackbar("Success", "Note added");
    } catch (e) {
      Get.snackbar("Error", "Failed to add note");
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
        userId: userId,
        title: title,
        description: desc,
        colorIndex: DateTime.now().millisecond % 5,
      );

      await _service.updateNote(note);

      Get.snackbar("Success", "Note updated");
    } catch (e) {
      Get.snackbar("Error", "Failed to update note");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Delete Note
  Future<void> deleteNote(String id) async {
    try {
      await _service.deleteNote(id);

      Get.snackbar("Deleted", "Note removed");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete note");
    }
  }
}