import 'package:flutter/material.dart';
import 'package:flutter_notes_template/views/widgets/notes/note_edit_dialog.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({super.key, this.title, this.description});
  final String? title;
  final String? description;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showNoteDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => NoteEditDialog(
        titleController: titleController,
        descriptionController: descriptionController,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            titleController.text.isNotEmpty
              ? titleController.text
              : "New Note",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleController.text.isNotEmpty
                ? Colors.black
                : Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          descriptionController.text.isNotEmpty
            ? descriptionController.text
            : "What's in your mind?",
          style: TextStyle(
            fontSize: 16,
            color: descriptionController.text.isNotEmpty
              ? Colors.black
              : Colors.grey,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
