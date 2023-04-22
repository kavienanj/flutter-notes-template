import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/team_bloc/team_bloc.dart';

class TeamCreateDialog extends StatelessWidget {
  const TeamCreateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20),
      title: const Text('Create New Team'),
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Team Name',
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<TeamBloc>().add(TeamCreate(controller.text));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ],
    );
  }
}
