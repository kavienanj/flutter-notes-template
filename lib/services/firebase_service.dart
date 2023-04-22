import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes_template/models/note.dart';
import 'package:flutter_notes_template/models/team.dart';
import 'package:flutter_notes_template/models/team_member.dart';

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

  String get _userNotesKey => 'notes/${user.email}';
  String get _userAllNotesKey => 'notes/${user.email}/all';
  String get _userTeamsKey => 'notes/${user.email}/teams';
  String _memberTeamsKey(String memberEmail) => 'notes/$memberEmail/teams';
  String get _teamsAllKey => 'teams';
  String _teamNotesKey(Team team) => 'notes/${team.id}';
  String _teamAllNotesKey(Team team) => 'notes/${team.id}/all';

  Future<Note> createNote(String title, String description) async {
    final json = {"title": title, "description": description};
    final docRef = await db.collection(_userAllNotesKey).add(json);
    return Note.fromJson({'id': docRef.id, ...json});
  }

  Future<Note> createTeamNote(Team team, String title, String description) async {
    final json = {"title": title, "description": description};
    final docRef = await db.collection(_teamAllNotesKey(team)).add(json);
    return Note.fromJson({'id': docRef.id, ...json});
  }

  Future<void> editNote(Note note) async {
    await db.collection(_userAllNotesKey).doc(note.id).set(note.toJson());
  }

  Future<void> editTeamNote(Team team, Note note) async {
    await db.collection(_teamAllNotesKey(team)).doc(note.id).set(note.toJson());
  }

  Future<void> deleteNote(Note note) async {
    await db.collection(_userAllNotesKey).doc(note.id).delete();
  }

  Future<void> deleteTeamNote(Team team, Note note) async {
    await db.collection(_teamAllNotesKey(team)).doc(note.id).delete();
  }

  Future<List<String>?> getNotesOrderFuture() async {
    final notesOrderDoc = await db.doc(_userNotesKey).get();
    return (notesOrderDoc.data()?["notes_order"] as List?)?.cast<String>();
  }

  Future<List<String>?> getTeamNotesOrderFuture(Team team) async {
    final notesOrderDoc = await db.doc(_teamNotesKey(team)).get();
    return (notesOrderDoc.data()?["notes_order"] as List?)?.cast<String>();
  }

  Future<void> setNotesOrder(List<String> noteIdsOrder) async {
    await db.doc(_userNotesKey).set({
      'notes_order': noteIdsOrder,
    });
  }

  Future<void> setTeamNotesOrder(Team team, List<String> noteIdsOrder) async {
    await db.doc(_teamNotesKey(team)).set({
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

  Stream<List<Note>> getTeamNotesStream(Team team) {
    final notesSnaps = db.collection(_teamAllNotesKey(team)).snapshots();
    return notesSnaps.map<List<Note>>(
      (snap) => snap.docs.map<Note>(
        (doc) => Note.fromJson({'id': doc.id, ...doc.data()}),
      ).toList(),
    );
  }

  // Team & TeamMember

  Stream<TeamMember> getTeamMemberStream(String userEmail, String teamId)  {
    final memberDoc = db.collection(_memberTeamsKey(userEmail)).doc(teamId).snapshots();
    return memberDoc.map<TeamMember>(
      (doc) => TeamMember.fromJson(
        {'id': doc.id, 'user': userEmail, ...doc.data()!},
      )
    );
  }

  Future<TeamMember> editOrCreateTeamMember(String userEmail, String teamId, TeamMemberRole role) async {
    final json = {
      'is_admin': role == TeamMemberRole.admin || role == TeamMemberRole.owner,
      'is_owner': role == TeamMemberRole.owner,
      'can_edit': role != TeamMemberRole.viewer,
    };
    await db.collection(_memberTeamsKey(userEmail)).doc(teamId).set(json);
    return TeamMember.fromJson({'id': teamId, 'user': userEmail, ...json});
  }

  Future<void> deleteTeamMember(TeamMember teamMember) async {
    await db.collection(_memberTeamsKey(teamMember.userEmail)).doc(teamMember.teamId).delete();
  }

  Stream<List<TeamMember>> getUserTeamsStream() {
    final teamsSnaps = db.collection(_userTeamsKey).snapshots();
    return teamsSnaps.map<List<TeamMember>>(
      (snap) => snap.docs.map<TeamMember>(
        (doc) => TeamMember.fromJson(
          {'id': doc.id, 'user': user.email, ...doc.data()},
        ),
      ).toList(),
    );
  }

  Future<Team> createTeam(String teamName) async {
    final json = {"name": teamName, "members": <String>[], "owner": user.email};
    final docRef = await db.collection(_teamsAllKey).add(json);
    return Team.fromJson({'id': docRef.id, ...json});
  }

  Future<void> editTeam(Team team) async {
    await db.collection(_teamsAllKey).doc(team.id).set(team.toJson());
  }

  Stream<Team> getTeamStream(String teamId) {
    final teamDoc = db.collection(_teamsAllKey).doc(teamId).snapshots();
    return teamDoc.map<Team>(
      (doc) => Team.fromJson({'id': doc.id, ...doc.data()!})
    );
  }

  Future<void> deleteTeam(Team team) async {
    await db.collection(_teamsAllKey).doc(team.id).delete();
  }
}
