import 'package:flutter/material.dart';
import 'package:flutter_notes_template/views/widgets/forms/signin.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        centerTitle: true,
      ),
      body: const Center(
        child: SignInForm(),
      ),
    );
  }
}
