import 'package:medlink/features/auth/domain/entities/auth_session.dart';
import 'package:medlink/features/auth/domain/entities/register_data.dart';
import 'package:medlink/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser {
  const RegisterUser(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call(RegisterData data) => _repository.register(data);
}
