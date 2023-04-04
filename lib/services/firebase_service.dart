import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {

  FirebaseService({required this.auth});
  final FirebaseAuth auth;

  bool isSignedIn() => auth.currentUser != null;
}
