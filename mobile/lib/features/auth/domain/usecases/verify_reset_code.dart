import 'package:medlink/features/auth/domain/repositories/password_reset_reopsitory.dart';

class VerifyResetCode {
  const VerifyResetCode(this._repository);

  final PasswordResetRepository _repository;

  Future<String> call({required String email, required String code}) =>
      _repository.verifyCode(email: email, code: code);
}
