import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveTextField extends StatelessWidget {
  const CustomReactiveTextField({
    super.key,
    required this.formControlName,
  });

  final String formControlName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ReactiveTextField(
        formControlName: formControlName,
        decoration: InputDecoration(labelText: formControlName),
      ),
    );
  }
}

class CustomReactivePasswordField extends StatelessWidget {
  const CustomReactivePasswordField({
    super.key,
    required this.formControlName,
  });

  final String formControlName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ReactiveTextField(
        formControlName: formControlName,
        obscureText: true,
        decoration: InputDecoration(labelText: formControlName),
      ),
    );
  }
}
