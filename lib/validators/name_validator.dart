String? Function(String?)? nameValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter your name';
  }
  return null;
};
