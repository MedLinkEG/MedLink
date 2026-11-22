abstract final class Validators {
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static final RegExp _egyptianPhone = RegExp(r'^01[0125]\d{8}$');

  static const minPasswordLength = 8;
  static const maxPasswordLength = 72;

  static bool isEmail(String value) => _email.hasMatch(value.trim());

  static bool isEgyptianPhone(String value) =>
      _egyptianPhone.hasMatch(value.replaceAll(' ', ''));
}
