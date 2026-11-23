import 'package:medlink/features/auth/domain/repositories/password_reset_reopsitory.dart';

class RequestPasswordReset {
  const RequestPasswordReset(this._repository);

  final PasswordResetRepository _repository;

  Future<void> call(String email) => _repository.requestReset(email);
}
