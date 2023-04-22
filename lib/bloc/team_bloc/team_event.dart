part of 'team_bloc.dart';

@immutable
abstract class TeamEvent {}

class TeamCreate extends TeamEvent {
  final String name;
  TeamCreate(this.name);
}

class TeamNameChange extends TeamEvent {
  final Team team;
  final String name;
  TeamNameChange({required this.team, required this.name});
}

class TeamDelete extends TeamEvent {
  final Team team;
  TeamDelete(this.team);
}

class TeamMemberAdd extends TeamEvent {
  final String userEmail;
  final Team team;
  final TeamMemberRole role;
  TeamMemberAdd({
    required this.userEmail,
    required this.team,
    required this.role,
  });
}

class TeamMemberRemove extends TeamEvent {
  final TeamMember teamMember;
  TeamMemberRemove(this.teamMember);
}

class TeamMemberRoleChange extends TeamEvent {
  final TeamMember teamMember;
  final TeamMemberRole role;
  TeamMemberRoleChange({
    required this.teamMember,
    required this.role,
  });
}
