String? Function(String?)? locationValidator = (String? value) {
  if (value!.isEmpty) {
    return 'Enter your current location';
  }
  return null;
};
