import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/team_bloc/team_bloc.dart';
import 'package:flutter_notes_template/models/team.dart';
import 'package:flutter_notes_template/models/team_member.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';
import 'package:flutter_notes_template/views/widgets/notes/team_notes_view.dart';
import 'package:flutter_notes_template/views/widgets/teams/team_settings_dialog.dart';

class TeamsView extends StatelessWidget {
  const TeamsView({super.key});

  Widget _loadingOrErrorView(AsyncSnapshot snapshot) => snapshot.hasError
    ? const Center(child: Text('Something went wrong try again!'))
    : const Center(child: CircularProgressIndicator());

  Widget _teamActionsThread(BuildContext context, Team team, TeamMember teamMember) {
    return IconTheme(
      data: const IconThemeData(size: 32),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 20, bottom: 20),
        child: Row(
          children: [
            const Icon(Icons.groups),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                team.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              tooltip: teamMember.hasEditPermission
                ? teamMember.isOwner 
                  ? 'Team Owner'
                  : teamMember.isAdmin ? 'Team Admin' : 'View & Edit'
                : 'View only',
              icon: Icon(teamMember.hasEditPermission
                ? teamMember.isAdmin ? Icons.person : Icons.edit
                : Icons.visibility,
              ),
            ),
            const SizedBox(width: 10),
            teamMember.isAdmin
              ? IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => TeamSettingsDialog(teamMember: teamMember),
                  ),
                  tooltip: 'Team Settings',
                  icon: const Icon(Icons.settings),
                )
              : IconButton(
                  onPressed: () {
                    context.read<TeamBloc>().add(TeamMemberRemove(
                      team: team,
                      teamMember: teamMember,
                    ));
                  },
                  tooltip: 'Leave Team',
                  icon: const Icon(Icons.exit_to_app),
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.read<FirebaseService>();
    return StreamBuilder(
      stream: service.getUserTeamsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _loadingOrErrorView(snapshot);
        final teamMemberList = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ for (var teamMember in teamMemberList)
            StreamBuilder(
              stream: service.getTeamStream(teamMember.teamId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return _loadingOrErrorView(snapshot);
                final team = snapshot.data!;
                return Column(
                  children: [
                    _teamActionsThread(context, team, teamMember),
                    TeamNotesGridView(team: team, teamMember: teamMember),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
