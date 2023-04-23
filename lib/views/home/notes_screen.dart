import 'package:flutter/material.dart';
import 'package:flutter_notes_template/views/widgets/core/actions_menu.dart';
import 'package:flutter_notes_template/views/widgets/notes/user_notes_view.dart';
import 'package:flutter_notes_template/views/widgets/teams/teams_view.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          ActionsPopupMenu(),
          SizedBox(width: 30),
        ],
      ),
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: UserNotesGridView(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: TeamsView(),
          ),
        ],
      ),
    );
  }
}
