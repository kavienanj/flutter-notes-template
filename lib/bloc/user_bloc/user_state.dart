part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {
  final User? user;
  UserInitial({this.user});
}

class UserSuccess extends UserState {
  final User user;
  UserSuccess(this.user);
}

class UserLoading extends UserState {}

class UserError extends UserState {
  final User? user;
  final String errorMessage;
  UserError({this.user, required this.errorMessage});
}
