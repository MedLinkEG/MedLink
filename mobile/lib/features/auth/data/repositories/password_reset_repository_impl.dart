import 'package:medlink/features/auth/data/datasources/password_reset_remote_data_source.dart';
import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';
import 'package:medlink/features/auth/domain/repositories/password_reset_reopsitory.dart';

class PasswordResetRepositoryImpl implements PasswordResetRepository {
  const PasswordResetRepositoryImpl(this._remote);

  final PasswordResetRemoteDataSource _remote;

  @override
  Future<void> requestReset(String email) => _remote.requestReset(email);

  @override
  Future<String> verifyCode({required String email, required String code}) =>
      _remote.verifyCode(email: email, code: code);

  @override
  Future<void> resetPassword(ResetPasswordData data) => _remote.resetPassword(
    resetToken: data.resetToken,
    newPassword: data.newPassword,
  );
}
