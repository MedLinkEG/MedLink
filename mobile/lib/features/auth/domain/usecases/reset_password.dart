import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';
import 'package:medlink/features/auth/domain/repositories/password_reset_reopsitory.dart';

class ResetPassword {
  const ResetPassword(this._repository);

  final PasswordResetRepository _repository;

  Future<void> call(ResetPasswordData data) =>
      _repository.resetPassword(data);
}
