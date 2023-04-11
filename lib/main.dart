import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_notes_template/bloc/user_bloc/user_bloc.dart';
import 'package:flutter_notes_template/services/firebase_service.dart';
import 'package:flutter_notes_template/firebase_options.dart';
import 'package:flutter_notes_template/views/auth/signin_screen.dart';
import 'package:flutter_notes_template/views/home/notes_screen.dart';
import 'package:flutter_notes_template/views/widgets/core/form_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirebaseService(
      auth: FirebaseAuth.instance,
      db: FirebaseFirestore.instance,
    );
    return MultiBlocProvider(
      providers: [
        Provider<FirebaseService>.value(value: service),
        BlocProvider(create: (context) => UserBloc(service)),
      ],
      child: ReactiveFormConfig(
        validationMessages: GlobalFormConfig.validationMessages,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Notes Template',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: service.auth.currentUser != null
            ? const NotesScreen()
            : const SignInScreen(),
        ),
      ),
    );
  }
}
