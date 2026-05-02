import 'package:cloud_firestore/cloud_firestore.dart';

import 'note_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get notes => _db.collection('notes');

  Future<void> addNote(NoteModel note) async {
    await notes.add(note.toMap());
  }

  Future<void> updateNote(NoteModel note) async {
    await notes.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await notes.doc(id).delete();
  }

  Stream<List<NoteModel>> getNotes(String userId) {
    return notes
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NoteModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}