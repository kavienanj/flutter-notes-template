import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/note_bloc/note_bloc.dart';
import 'package:flutter_notes_template/views/widgets/notes/note_text_field.dart';

class NoteEditDialog extends StatelessWidget {
  const NoteEditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NoteBloc>();
    return WillPopScope(
      onWillPop: () async {
        bloc.add(NoteClose());
        return true;
      },
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              final note = state is NoteTouched ? state.note : null;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: NoteTextField(
                      text: note?.title,
                      fontSize: 24.0,
                      hintText: 'Title',
                      fontWeight: FontWeight.bold,
                      onChanged: (title) => bloc.add(NoteEdit(title: title)),
                    ),
                  ),
                  NoteTextField(
                    text: note?.description,
                    multiline: true,
                    fontSize: 16.0,
                    hintText: "What's in your mind?",
                    onChanged: (description) => 
                      bloc.add(NoteEdit(description: description)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
