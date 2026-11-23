import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';

abstract interface class PasswordResetRepository {
  Future<void> requestReset(String email);

  Future<String> verifyCode({required String email, required String code});

  Future<void> resetPassword(ResetPasswordData data);
}
