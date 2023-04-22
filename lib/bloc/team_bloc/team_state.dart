part of 'team_bloc.dart';

@immutable
abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamError extends TeamState {
  final String errorMessage;
  TeamError(this.errorMessage);
}

class TeamCreated extends TeamState {}

class TeamNameChanged extends TeamState {}

class TeamDeleted extends TeamState {}

class TeamMemberAdded extends TeamState {}

class TeamMemberRemoved extends TeamState {}

class TeamMemberRoleChanged extends TeamState {}
