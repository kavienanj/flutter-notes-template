import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notes_template/models/note.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final FirebaseService service;
  final Note? note;
  NoteBloc({required this.service, required this.note}) : super(
    note == null ? NoteEmpty() : NoteTouched(note),
  ) {

    on<NoteOpen>((event, emit) => emit(NoteTouched(event.note)));

    on<NoteEdit>((event, emit) async {
      Note newNote;
      if (state is NoteEmpty) {
        newNote = await service.createNote({
          "title": event.title ?? "",
          "description": event.description ?? "",
          "index": 1,
        });
      } else {
        newNote = (state as NoteTouched).note.copyWith(
          title: event.title,
          description: event.description,
        );
        service.editNote(newNote);
      }
      emit(NoteTouched(newNote));
    }, transformer: sequential());

    on<NoteClose>((event, emit) async {
      if (state is NoteTouched) {
        final note = (state as NoteTouched).note;
        if (!note.hasContent) service.deleteNote(note);
      }
    });

  }
}
