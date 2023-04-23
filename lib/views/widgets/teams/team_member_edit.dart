import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/team_bloc/team_bloc.dart';
import 'package:flutter_notes_template/models/team.dart';
import 'package:flutter_notes_template/models/team_member.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';
import 'package:flutter_notes_template/views/widgets/core/form_fields.dart';

class TeamMemberPermissionsEditField extends StatelessWidget {
  const TeamMemberPermissionsEditField({
    super.key,
    required this.userEmail,
    required this.team,
    required this.editAdmins,
  });
  final String userEmail;
  final Team team;
  final bool editAdmins;

  static const String kAdmin = 'Admin';
  static const String kEditor = 'Editor';
  static const String kViewer = 'View Only';

  TeamMemberRole getRole(String role) {
    switch (role) {
      case kAdmin:
        return TeamMemberRole.admin;
      case kEditor:
        return TeamMemberRole.editor;
      case kViewer:
        return TeamMemberRole.viewer;
      default:
        return TeamMemberRole.viewer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.read<FirebaseService>();
    final teamBloc = context.read<TeamBloc>();
    return StreamBuilder(
      stream: service.getTeamMemberStream(userEmail, team.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final teamMember = snapshot.data!;
        return Row(
          children: [
            Text(teamMember.userEmail),
            const SizedBox(width: 16),
            if (!editAdmins && teamMember.isAdmin)
              const FixedValueDropdown(value: kAdmin)
            else
              DropdownButton(
                value: teamMember.hasEditPermission
                  ? teamMember.isAdmin ? kAdmin : kEditor
                  : kViewer,
                items: [kViewer, kEditor, if (editAdmins) kAdmin].map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                ).toList(),
                onChanged: (value) {
                  teamBloc.add(
                    TeamMemberRoleChange(
                      teamMember: teamMember,
                      role: getRole(value!),
                    ),
                  );
                },
              ),
            if (editAdmins || !teamMember.isAdmin) IconButton(
              splashRadius: 12,
              onPressed: () => teamBloc.add(
                TeamMemberRemove(
                  team: team,
                  teamMember: teamMember,
                ),
              ),
              color: Colors.red,
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ],
        );
      },
    );
  }
}
