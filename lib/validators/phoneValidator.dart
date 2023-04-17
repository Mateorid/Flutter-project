String? Function(String?)? phoneValidator = (String? value) {
  String pattern = r'^(\+[1-9]\d{0,2}|0)\s?\d{3,}(?:\s?\d{2,}){1,3}$';
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return 'Enter your contact phone number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
};
