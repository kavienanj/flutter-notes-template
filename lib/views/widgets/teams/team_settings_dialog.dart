import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/team_bloc/team_bloc.dart';
import 'package:flutter_notes_template/models/team_member.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';
import 'package:flutter_notes_template/views/widgets/core/form_fields.dart';
import 'package:flutter_notes_template/views/widgets/teams/team_member_edit.dart';

class TeamSettingsDialog extends StatelessWidget {
  const TeamSettingsDialog({super.key, required this.teamMember});
  final TeamMember teamMember;

  Widget _loadingOrErrorView(AsyncSnapshot snapshot) => snapshot.hasError
    ? const Center(child: Text("Something went wrong try again!"))
    : const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final service = context.read<FirebaseService>();
    final teamBloc = context.read<TeamBloc>();
    final newMemberEmailController = TextEditingController();
    TextEditingController? teamNameController;
    return StreamBuilder(
      stream: service.getTeamStream(teamMember.teamId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _loadingOrErrorView(snapshot);
        final team = snapshot.data!;
        teamNameController ??= TextEditingController(text: team.name);
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          children: [
            const Text(
              'Team Settings',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Team Name:"),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: teamNameController,
                    onChanged: (newName) => teamBloc.add(
                      TeamNameChange(
                        team: team,
                        name: newName.isNotEmpty
                          ? newName
                          : "Team"
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  teamMember.isOwner
                    ? 'You (${teamMember.userEmail})'
                    : team.owner,
                ),
                const SizedBox(width: 16),
                const FixedValueDropdown(value: 'Owner'),
              ],
            ),
            if (!teamMember.isOwner) Row(
              children: [
                Text('You (${teamMember.userEmail})'),
                const SizedBox(width: 16),
                const FixedValueDropdown(value: 'Admin'),
              ],
            ),
            for (final memberEmail in team.members) 
              if (memberEmail != teamMember.userEmail)
                TeamMemberPermissionsEditField(
                  userEmail: memberEmail,
                  team: team,
                  editAdmins: team.owner == teamMember.userEmail,
                ),
            BlocBuilder<TeamBloc, TeamState>(
              buildWhen: (previous, current) => 
                current is TeamMemberError || current is TeamMemberAdded,
              builder: (context, state) => Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newMemberEmailController,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        errorText: state is TeamMemberError
                          ? state.errorMessage
                          : null,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      teamBloc.add(TeamMemberAdd(
                        userEmail: newMemberEmailController.text,
                        team: team,
                        role: TeamMemberRole.editor,
                      ));
                      newMemberEmailController.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Member'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            teamMember.isOwner
              ? ElevatedButton(
                  onPressed: () {
                    teamBloc.add(TeamDelete(team));
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Delete Team'),
                )
              : ElevatedButton(
                  onPressed: () {
                    teamBloc.add(TeamMemberRemove(
                      team: team,
                      teamMember: teamMember,
                    ));
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Leave Team'),
                ),
          ],
        );
      },
    );
  }
}
