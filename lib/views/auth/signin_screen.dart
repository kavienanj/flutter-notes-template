import 'package:flutter/material.dart';
import 'package:flutter_notes_template/views/auth/signup_screen.dart';
import 'package:flutter_notes_template/views/widgets/forms/signin.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SignInForm(),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            ),
            child: const Text("Don't have an account yet, Sign Up"),
          ),
        ],
      ),
    );
  }
}
