import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth authService;
  UserBloc(this.authService) : super(UserInitial()) {
  
    on<UserCreate>((event, emit) async {
      try {
        emit(UserLoading());
        final userCredential = await authService.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(
          userCredential.user != null
            ? UserSuccess(userCredential.user!)
            : UserError(errorMessage: "Something went wrong, Try again!")
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(UserError(errorMessage: "The password provided is too weak"));
        } else if (e.code == 'email-already-in-use') {
          emit(UserError(errorMessage: "The account already exists for that email"));
        }
      }
    });

    on<UserSignIn>((event, emit) async {
      try {
        emit(UserLoading());
        final userCredential = await authService.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(
          userCredential.user != null
            ? UserSuccess(userCredential.user!)
            : UserError(errorMessage: "Something went wrong, Try again!")
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(UserError(errorMessage: "No user found for that email."));
        } else if (e.code == 'wrong-password') {
          emit(UserError(errorMessage: "Wrong password provided."));
        }
      }
    });

  }
}
