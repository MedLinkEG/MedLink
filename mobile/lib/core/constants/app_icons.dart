import 'package:flutter/material.dart';

/// Every icon the app uses, in one place.
abstract final class AppIcons {
  // Welcome features
  static const IconData search = Icons.search_rounded;
  static const IconData notifications = Icons.notifications_none_rounded;
  static const IconData verified = Icons.verified_user_outlined;

  // Language button
  static const IconData language = Icons.translate_rounded;

  // Log in
  static const IconData add = Icons.add_rounded;
  static const IconData email = Icons.mail_outline_rounded;
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData showPassword = Icons.visibility_outlined;
  static const IconData hidePassword = Icons.visibility_off_outlined;
  static const IconData fingerprint = Icons.fingerprint_rounded;
}
