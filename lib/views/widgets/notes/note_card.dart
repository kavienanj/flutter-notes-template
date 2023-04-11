import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/note_bloc/note_bloc.dart';
import 'package:flutter_notes_template/models/note.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';
import 'package:flutter_notes_template/views/widgets/notes/note_edit_dialog.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, this.note});
  final Note? note;

  void _showNoteDialog(BuildContext context) async => await showDialog(
    context: context,
    builder: (context) => BlocProvider(
      create: (context) => NoteBloc(
        service: context.read<FirebaseService>(),
        note: note,
      ),
      child: const NoteEditDialog(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final hasTitle = note?.title.isNotEmpty ?? false;
    final hasDescription = note?.description.isNotEmpty ?? false;
    return PhysicalModel(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.white,
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        onTap: () => _showNoteDialog(context),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Text(
            hasTitle ? note!.title : "New Note",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: hasTitle ? Colors.black : Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          hasDescription ? note!.description : "What's in your mind?",
          style: TextStyle(
            fontSize: 16,
            color: hasDescription ? Colors.black : Colors.grey,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
