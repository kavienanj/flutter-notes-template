import 'dart:math';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes_template/views/widgets/notes/note_card.dart';
import 'package:flutter_notes_template/models/note.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';

class UserNotesGridView extends StatelessWidget {
  const UserNotesGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.read<FirebaseService>();
    return FutureBuilder(
      future: service.getNotesOrderFuture(),
      builder: (context, snapshot) {
        var notesOrder = snapshot.data ?? <String>[];
        return StreamBuilder(
          stream: service.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong try again!"),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final notes = [...snapshot.data!];
            notes.sort((n1, n2) => notesOrder.indexOf(n1.id)
              .compareTo(notesOrder.indexOf(n2.id)),
            );
            notes.insert(0, Note.empty);
            final columns = max(1, (MediaQuery.of(context).size.width / 350).round());
            return StatefulBuilder(
              builder: (context, setState) => ReorderableGridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: min(4, columns),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                ),
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex == 0 || newIndex == 0) return;
                  setState(() {
                    final item = notes.removeAt(oldIndex);
                    notes.insert(newIndex, item);
                    notesOrder = [for (var note in notes.sublist(1)) note.id];
                    service.setNotesOrder(notesOrder);
                  });
                },
                children: [ for (var note in notes)
                  NoteCard(
                    key: ValueKey(note.id),
                    note: note == Note.empty ? null : note,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
