import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/user_bloc/user_bloc.dart';
import 'package:flutter_notes_template/views/home/notes_screen.dart';
import 'package:flutter_notes_template/views/widgets/core/buttons.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_notes_template/views/widgets/core/form_fields.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final _emailInputLabel = 'Email';
  final _passwordInputLabel = 'Password';
  final _passwordConfirmInputLabel = 'Confirm Password';
  late FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      _emailInputLabel: FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      _passwordInputLabel: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
        ],
      ),
      _passwordConfirmInputLabel: FormControl<String>(),
    },
    validators: [
      Validators.mustMatch(_passwordInputLabel, _passwordConfirmInputLabel),
    ]);
  }

  void _createUser() => context.read<UserBloc>().add(UserCreate(
    _form.controls[_emailInputLabel]!.value as String,
    _form.controls[_passwordInputLabel]!.value as String,
  ));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ReactiveForm(
        formGroup: _form,
        child: Column(
          children: <Widget>[
            CustomReactiveTextField(
              formControlName: _emailInputLabel,
            ),
            CustomReactivePasswordField(
              formControlName: _passwordInputLabel,
              helperText: '8 or more characters',
            ),
            CustomReactivePasswordField(
              formControlName: _passwordConfirmInputLabel,
            ),
            BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const NotesScreen()),
                  );
                }
              },
              builder: (context, state) {
                if (state is UserError) {
                  _form.controls[_emailInputLabel]!.setErrors({
                    state.errorMessage: true,
                  });
                }
                if (state is UserEmpty || state is UserError) {
                  return ReactiveFormConsumer(
                    builder: (context, form, child) => LongElevatedButton(
                      label: 'Create New User',
                      onPressed: _form.valid ? _createUser : null,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
