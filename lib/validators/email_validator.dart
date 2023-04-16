import 'package:email_validator/email_validator.dart';

String? Function(String?)? emailValidator = (String? value) {
  if (value!.isEmpty) {
    return 'Enter your contact email';
  }
  if (!EmailValidator.validate(value)) {
    return 'Please enter a valid email';
  }
  return null;
};