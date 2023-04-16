String? Function(String?)? nameValidator = (String? value) {
  if (value!.isEmpty) {
    return 'Enter your name';
  }
  return null;
};