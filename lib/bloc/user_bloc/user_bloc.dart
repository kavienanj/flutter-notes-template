import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseService service;
  UserBloc(this.service) : super(
    service.userSignedIn ? UserSuccess(service.user) : UserEmpty()
  ) {
  
    on<UserCreate>((event, emit) async {
      try {
        emit(UserLoading());
        final userCredential = await service.createUser(event.email, event.password);
        if (userCredential.user != null) {
          add(UserSignIn(event.email, event.password));
        } else {
          emit(UserError(errorMessage: "Something went wrong, Try again!"));
        }
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
        final userCredential = await service.signInUser(event.email, event.password);
        emit(
          userCredential.user != null
            ? UserSuccess(service.user)
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

    on<UserSignOut>((event, emit) async {
      await service.signOutUser();
      emit(UserEmpty());
    });
  
  }
}
