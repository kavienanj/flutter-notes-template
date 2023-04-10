import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes_template/models/note.dart';

class FirebaseService {

  FirebaseService({
    required this.auth,
    required this.db,
  });
  final FirebaseAuth auth;
  final FirebaseFirestore db;

  static const _notesDbKey = 'notes';

  Future<void> createNote(Map<String, dynamic> json) async {
    await db.collection(_notesDbKey).doc().set(json);
  }

  Future<void> editNote(Note note) async {
    await db.collection(_notesDbKey).doc(note.id).set(note.toJson());
  }

  Stream<List<Note>> getNotesesStream() {
    final notesSnaps = db.collection(_notesDbKey).snapshots();
    return notesSnaps.map<List<Note>>(
      (snap) => snap.docs.map<Note>(
        (doc) => Note.fromJson(doc.data()..addEntries([
          MapEntry('id', doc.id),
        ])),
      ).toList(),
    );
  }
}
