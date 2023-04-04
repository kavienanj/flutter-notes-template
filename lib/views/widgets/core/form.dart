import 'dart:async';
import 'package:reactive_forms/reactive_forms.dart';

extension SubmissionHandler on FormGroup {

  FutureOr<void> Function()? submitIfValidElseDisable(void Function() submit) => 
    valid ? () => submit() : null;
}
