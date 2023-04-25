import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/note_bloc/note_bloc.dart';
import 'package:flutter_notes_template/models/note.dart';

class NoteDetailsToggleThread extends StatefulWidget {
  final Note note;
  const NoteDetailsToggleThread({super.key, required this.note});

  @override
  State<NoteDetailsToggleThread> createState() => _NoteDetailsToggleThreadState();
}

class _NoteDetailsToggleThreadState extends State<NoteDetailsToggleThread> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NoteBloc>();
    final note = widget.note;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: showDetails ? BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showDetails) TextButton.icon(
            onPressed: () => setState(() => showDetails = true),
            icon: const Icon(Icons.info_outline),
            label: const Text('Note Info'),
          ),
          if (showDetails) TextButton.icon(
            onPressed: () => setState(() => showDetails = false),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
          ),
          const SizedBox(width: 20),
          if (showDetails) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created By:\t\t${note.createdBy}'
                  '\n\nCreated On:\t\t${note.createdAt}'
                  '${ 
                    note.editHistory.length > 1
                      ? '\n\nEdit History:\n${[
                          for (var entry in note.sortedEditHistory.entries)
                            '\t\t\t\t${entry.key} last edited on ${entry.value}',
                        ].join("\n")}'
                      : '\n\nLast Edited By:\t\t${note.lastEditedUser}'
                        '\nLast Edited On:\t\t${note.lastEditedTime}'
                  }',
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    bloc.add(NoteDelete(note));
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Note'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
