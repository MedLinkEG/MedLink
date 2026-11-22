import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';

abstract interface class PasswordResetRepository {
  /// Checks the email and starts a password reset for it.
  Future<void> requestReset(String email);

  /// Saves the new password.
  Future<void> resetPassword(ResetPasswordData data);
}