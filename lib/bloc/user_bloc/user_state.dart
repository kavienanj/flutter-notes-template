part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserEmpty extends UserState {}

class UserSuccess extends UserState {
  final User user;
  UserSuccess(this.user);
}

class UserLoading extends UserState {}

class UserError extends UserState {
  final String errorMessage;
  UserError({required this.errorMessage});
}
