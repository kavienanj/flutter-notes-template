import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/team_bloc/team_bloc.dart';
import 'package:flutter_notes_template/models/team_member.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';

class FixedValueDropdown extends StatelessWidget {
  const FixedValueDropdown({super.key, required this.value,});
  final String value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: value,
      items: [DropdownMenuItem(
        value: value,
        child: Text(value),
      )],
      onChanged: null,
    );
  }
}

class TeamMemberPermissionsEditField extends StatelessWidget {
  const TeamMemberPermissionsEditField({
    super.key,
    required this.userEmail,
    required this.teamId,
    required this.editAdmins,
  });
  final String userEmail;
  final String teamId;
  final bool editAdmins;

  Widget _loadingOrErrorView(AsyncSnapshot snapshot) => snapshot.hasError
    ? const Center(child: Text("Something went wrong try again!"))
    : const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final service = context.read<FirebaseService>();
    return StreamBuilder(
      stream: service.getTeamMemberStream(userEmail, teamId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _loadingOrErrorView(snapshot);
        final teamMember = snapshot.data!;
        return Row(
          children: [
            Text(teamMember.userEmail),
            const SizedBox(width: 16),
            if (!editAdmins && teamMember.isAdmin)
              const FixedValueDropdown(value: 'Admin')
            else
              DropdownButton(
                value: teamMember.hasEditPermission
                  ? teamMember.isAdmin ? 'Admin' : 'Edit'
                  : 'View Only',
                items: ["View Only", "Edit", if (editAdmins) "Admin"].map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                ).toList(),
                onChanged: (value) {},
              ),
            if (editAdmins || !teamMember.isAdmin) IconButton(
              splashRadius: 12,
              onPressed: () {},
              color: Colors.red,
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ],
        );
      }
    );
  }
}

class TeamSettingsDialog extends StatelessWidget {
  const TeamSettingsDialog({super.key, required this.teamMember});
  final TeamMember teamMember;

  Widget _loadingOrErrorView(AsyncSnapshot snapshot) => snapshot.hasError
    ? const Center(child: Text("Something went wrong try again!"))
    : const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final service = context.read<FirebaseService>();
    return StreamBuilder(
      stream: service.getTeamStream(teamMember.teamId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _loadingOrErrorView(snapshot);
        final team = snapshot.data!;
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
                    controller: TextEditingController(text: team.name),
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
                  teamId: team.id,
                  editAdmins: team.owner == teamMember.userEmail,
                ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add New Member'),
            ),
            const SizedBox(height: 16),
            teamMember.isOwner
              ? ElevatedButton(
                  onPressed: () {
                    context.read<TeamBloc>().add(TeamDelete(team));
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Delete Team'),
                )
              : ElevatedButton(
                  onPressed: () {
                    context.read<TeamBloc>().add(TeamMemberRemove(
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
      }
    );
  }
}
