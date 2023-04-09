part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserCreate extends UserEvent {
  final String email;
  final String password;
  UserCreate(this.email, this.password);
}

class UserSignIn extends UserEvent {
  final String email;
  final String password;
  UserSignIn(this.email, this.password);
}

class UserSignOut extends UserEvent {}
