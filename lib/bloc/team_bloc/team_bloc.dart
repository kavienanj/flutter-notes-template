import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
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
  }
}
