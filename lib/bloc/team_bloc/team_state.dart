part of 'team_bloc.dart';

@immutable
abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamMemberError extends TeamState {
  final String errorMessage;
  TeamMemberError(this.errorMessage);
}

class InvalidTeamMember extends TeamMemberError {
  InvalidTeamMember() : super("Invalid user email");
}

class TeamMemberExists extends TeamMemberError {
  TeamMemberExists() : super("Member already exists in team");
}

class TeamMemberDoesNotExist extends TeamMemberError {
  TeamMemberDoesNotExist() : super("User does not exist");
}

class TeamCreated extends TeamState {}

class TeamNameChanged extends TeamState {}

class TeamDeleted extends TeamState {}

class TeamMemberAdded extends TeamState {}

class TeamMemberRemoved extends TeamState {}

class TeamMemberRoleChanged extends TeamState {}
