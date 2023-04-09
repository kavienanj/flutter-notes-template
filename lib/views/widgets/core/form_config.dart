import 'package:reactive_forms/reactive_forms.dart';

class GlobalFormConfig {
  static final validationMessages = {
    ValidationMessage.required: (error) => 'Field must not be empty',
    ValidationMessage.email: (error) => 'Enter a valid email',
    ValidationMessage.minLength: (error) => 'Should be atleast 8 characters',
    ValidationMessage.mustMatch: (error) => 'Password doesn\'t match',
  };
}
