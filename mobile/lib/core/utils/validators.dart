import 'package:medlink/l10n/generated/app_localizations.dart';

abstract final class Validators {
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isEmail(String value) => _email.hasMatch(value.trim());
}

String? _validateEmail(String? value, AppLocalizations l10n) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return l10n.emailRequired;
  if (!Validators.isEmail(email)) return l10n.emailInvalid;
  return null;
}
