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

class NoteDelete extends NoteEvent {
  final Note note;
  
  NoteDelete(this.note);
}

class NoteClose extends NoteEvent {}
