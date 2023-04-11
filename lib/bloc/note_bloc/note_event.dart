part of 'note_bloc.dart';

@immutable
abstract class NoteEvent {}

class NoteOpen extends NoteEvent {
  final Note note;

  NoteOpen(this.note);
}

class NoteEdit extends NoteEvent {
  final String? title;
  final String? description;

  NoteEdit({this.title, this.description});
}

class NoteClose extends NoteEvent {}
