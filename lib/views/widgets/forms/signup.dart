import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_template/bloc/user_bloc/user_bloc.dart';
import 'package:flutter_notes_template/views/widgets/core/buttons.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_notes_template/views/widgets/core/form_fields.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final _emailOrPhoneNumberInputLabel = "Email or phone number";
  final _passwordInputLabel = "Password";
  late FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      _emailOrPhoneNumberInputLabel: FormControl<String>(
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
    });
  }

  void _createUser() => context.read<UserBloc>().add(UserCreate(
    _form.controls[_emailOrPhoneNumberInputLabel]!.value as String,
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
              formControlName: _emailOrPhoneNumberInputLabel,
            ),
            CustomReactivePasswordField(
              formControlName: _passwordInputLabel,
              helperText: "8 or more characters",
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const CircularProgressIndicator();
                } else if (state is UserSuccess) {
                  return Text("Created account ${state.user}");
                } else if (state is UserError) {
                  _form.controls[_emailOrPhoneNumberInputLabel]!.setErrors({
                    state.errorMessage: true,
                  });
                }
                return ReactiveFormConsumer(
                  builder: (_, __, ___) => LongElevatedButton(
                    label: 'Create New User',
                    onPressed: _form.valid ? _createUser : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
