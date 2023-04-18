import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notes_template/models/note.dart';
import 'package:flutter_notes_template/models/team.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final FirebaseService service;
  final Note? note;
  final Team? team;
  NoteBloc({required this.service, required this.note, required this.team})
  : super(note == null ? NoteEmpty() : NoteTouched(note)) {

    on<NoteOpen>((event, emit) => emit(NoteTouched(event.note)));

    on<NoteEdit>((event, emit) async {
      Note newNote;
      if (state is NoteEmpty) {
        newNote = await _createNote(
          event.title ?? "",
          event.description ?? "",
        );
      } else {
        newNote = (state as NoteTouched).note.copyWith(
          title: event.title,
          description: event.description,
        );
        _editNote(newNote);
      }
      emit(NoteTouched(newNote));
    }, transformer: sequential());

    on<NoteClose>((event, emit) async {
      if (state is NoteTouched) {
        final note = (state as NoteTouched).note;
        if (!note.hasContent) _deleteNote(note);
      }
    });

  }

  Future<Note> _createNote(String title, String description) => team == null
    ? service.createNote(title, description)
    : service.createTeamNote(team!, title, description);

  Future<void> _editNote(Note note) => team == null
    ? service.editNote(note)
    : service.editTeamNote(team!, note);

  Future<void> _deleteNote(Note note) => team == null
    ? service.deleteNote(note)
    : service.deleteTeamNote(team!, note);
}
