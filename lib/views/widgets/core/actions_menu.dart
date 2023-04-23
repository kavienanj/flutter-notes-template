import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/user_bloc/user_bloc.dart';
import 'package:flutter_notes_template/views/auth/signin_screen.dart';
import 'package:flutter_notes_template/views/widgets/teams/team_create_dialog.dart';

class ActionsPopupMenu extends StatelessWidget {
  const ActionsPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final userEmail = (userBloc.state as UserSuccess).user.email!;
    return PopupMenuButton<int>(
      offset: const Offset(0, 55),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: const [
              Icon(Icons.add, color: Colors.black),
              SizedBox(width: 10),
              Text(
                'Create New Team',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.black),
              SizedBox(width: 10),
              Text(
                'Sign Out',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
      onSelected: (i) {
        if (i == 0) {
          showDialog(
            context: context,
            builder: (context) => const TeamCreateDialog(),
          );
        } else if (i == 1) {
          context.read<UserBloc>().add(UserSignOut());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        }
      },
      child: Row(
        children: [
          CircleAvatar(child: Text(userEmail[0].toUpperCase())),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
