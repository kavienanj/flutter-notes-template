import 'package:flutter/material.dart';
import 'package:flutter_notes_template/views/widgets/notes/note_text_field.dart';

class NoteEditDialog extends StatelessWidget {
  const NoteEditDialog({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: NoteTextField(
                controller: titleController,
                fontSize: 24.0,
                hintText: "Title",
                fontWeight: FontWeight.bold,
                onEditingComplete: Navigator.of(context).pop,
              ),
            ),
            NoteTextField(
              multiline: true,
              controller: descriptionController,
              fontSize: 16.0,
              hintText: "What's in your mind?",
              onEditingComplete: Navigator.of(context).pop,
            ),
          ],
        ),
      ),
    );
  }
}
