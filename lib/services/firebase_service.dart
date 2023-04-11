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

  // AUTH

  bool get userSignedIn => auth.currentUser != null;

  User get user => auth.currentUser!;

  Future<UserCredential> createUser(String email, String password) =>
    auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signInUser(String email, String password) =>
    auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOutUser() => auth.signOut();

  // FIRESTORE

  String get _notesDbKey => 'notes/${user.uid}/all';

  Future<Note> createNote(Map<String, dynamic> json) async {
    final docRef = await db.collection(_notesDbKey).add(json);
    return Note.fromJson(json..addEntries([
      MapEntry('id', docRef.id),
    ]));
  }

  Future<void> editNote(Note note) async {
    await db.collection(_notesDbKey).doc(note.id).set(note.toJson());
  }

  Future<void> deleteNote(Note note) async {
    await db.collection(_notesDbKey).doc(note.id).delete();
  }

  Stream<List<Note>> getNotesStream() {
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
