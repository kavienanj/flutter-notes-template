import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/user_bloc/user_bloc.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';
import 'package:flutter_notes_template/views/auth/signin_screen.dart';
import 'package:flutter_notes_template/views/widgets/notes/note_card.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final userEmail = (userBloc.state as UserSuccess).user.email!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          CircleAvatar(child: Text(userEmail[0].toUpperCase())),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<UserBloc>().add(UserSignOut());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              child: const Text("Sign Out"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
        child: StreamBuilder(
          stream: context.read<FirebaseService>().getNotesStream(),
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
            final notes = snapshot.data!;
            final columns = max(1, (MediaQuery.of(context).size.width / 350).round());
            return GridView.builder(
              itemCount: notes.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: min(4, columns),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, i) => i == 0
                ? const NoteCard()
                : NoteCard(note: notes[i - 1]),
            );
          }
        ),
      ),
    );
  }
}
