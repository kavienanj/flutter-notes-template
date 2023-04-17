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

  String get _userAllNotesKey => 'notes/${user.uid}/all';
  String get _userNotesKey => 'notes/${user.uid}';

  Future<Note> createNote(String title, String description) async {
    final json = {"title": title, "description": description};
    final docRef = await db.collection(_userAllNotesKey).add(json);
    return Note.fromJson({'id': docRef.id, ...json});
  }

  Future<void> editNote(Note note) async {
    await db.collection(_userAllNotesKey).doc(note.id).set(note.toJson());
  }

  Future<void> deleteNote(Note note) async {
    await db.collection(_userAllNotesKey).doc(note.id).delete();
  }

  Future<List<String>?> getNotesOrderFuture() async {
    final notesOrderDoc = await db.doc(_userNotesKey).get();
    return (notesOrderDoc.data()?["notes_order"] as List?)?.cast<String>();
  }

  Future<void> setNotesOrder(List<String> noteIdsOrder) async {
    await db.doc(_userNotesKey).set({
      'notes_order': noteIdsOrder,
    });
  }

  Stream<List<Note>> getNotesStream() {
    final notesSnaps = db.collection(_userAllNotesKey).snapshots();
    return notesSnaps.map<List<Note>>(
      (snap) => snap.docs.map<Note>(
        (doc) => Note.fromJson({'id': doc.id, ...doc.data()}),
      ).toList(),
    );
  }
}
