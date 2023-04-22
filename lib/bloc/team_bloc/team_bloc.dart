import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notes_template/models/team.dart';
import 'package:flutter_notes_template/models/team_member.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final FirebaseService service;
  TeamBloc(this.service) : super(TeamInitial()) {

    on<TeamCreate>((event, emit) async {
      emit(TeamLoading());
      final newTeam = await service.createTeam(event.name);
      await service.editOrCreateTeamMember(newTeam.owner, newTeam.id, TeamMemberRole.owner);
      emit(TeamCreated());
    });

    on<TeamNameChange>((event, emit) async {
      emit(TeamLoading());
      await service.editTeam(event.team.copyWith(name: event.name));
      emit(TeamNameChanged());
    });

    on<TeamDelete>((event, emit) async {
      emit(TeamLoading());
      for (final memberEmail in [event.team.owner, ...event.team.members]) {
        service.deleteTeamMember(memberEmail, event.team.id);
      }
      await service.deleteTeam(event.team);
      emit(TeamDeleted());
    });

    on<TeamMemberAdd>((event, emit) async {
      if ([event.team.owner, ...event.team.members].contains(event.userEmail)) {
        return;
      }
      emit(TeamLoading());
      await service.editTeam(
        event.team.copyWith(
          members: [...event.team.members, event.userEmail],
        ),
      );
      await service.editOrCreateTeamMember(
        event.userEmail,
        event.team.id,
        event.role,
      );
      emit(TeamMemberAdded());
    });

    on<TeamMemberRemove>((event, emit) async {
      emit(TeamLoading());
      await service.editTeam(
        event.team.copyWith(
          members: event.team.members.where(
            (member) => member != event.teamMember.userEmail
          ).toList(),
        ),
      );
      await service.deleteTeamMember(event.teamMember.userEmail, event.teamMember.teamId);
      emit(TeamMemberRemoved());
    });

    on<TeamMemberRoleChange>((event, emit) async {
      emit(TeamLoading());
      await service.editOrCreateTeamMember(
        event.teamMember.userEmail,
        event.teamMember.teamId,
        event.role,
      );
      emit(TeamMemberRoleChanged());
    });
  }
}
