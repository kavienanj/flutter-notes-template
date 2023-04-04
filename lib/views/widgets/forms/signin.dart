import 'package:flutter/material.dart';
import 'package:flutter_notes_template/views/widgets/core/buttons.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_notes_template/views/widgets/core/form.dart';
import 'package:flutter_notes_template/views/widgets/core/form_fields.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  static const _emailOrPhoneNumberInputLabel = "Email or phone number";
  static const _passwordInputLabel = "Password";

  @override
  Widget build(BuildContext context) {
    final form = FormGroup({
      _emailOrPhoneNumberInputLabel: FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      _passwordInputLabel: FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
    });
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          children: <Widget>[
            const CustomReactiveTextField(
              formControlName: _emailOrPhoneNumberInputLabel,
            ),
            const CustomReactivePasswordField(
              formControlName: _passwordInputLabel,
            ),
            ReactiveFormConsumer(
              builder: (_, __, ___) => MoriiLongElevatedButton(
                label: 'Sign In',
                onPressed: form.submitIfValidElseDisable(() { })
              ),
            ),
          ],
        ),
      ),
    );
  }
}
