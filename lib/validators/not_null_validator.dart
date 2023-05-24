String? Function(String?)? notNullValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Can\'t be left empty!';
  }
  return null;
};
