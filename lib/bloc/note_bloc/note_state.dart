part of 'note_bloc.dart';

@immutable
abstract class NoteState {}

class NoteEmpty extends NoteState {}

class NoteTouched extends NoteState {
  final Note note;

  NoteTouched(this.note);
}
