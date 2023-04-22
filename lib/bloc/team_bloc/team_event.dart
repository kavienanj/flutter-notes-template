part of 'team_bloc.dart';

@immutable
abstract class TeamEvent {}

class TeamCreate extends TeamEvent {
  final String name;
  TeamCreate(this.name);
}
