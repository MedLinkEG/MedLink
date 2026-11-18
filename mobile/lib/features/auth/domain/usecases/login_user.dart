import 'package:medlink/features/auth/domain/entities/auth_session.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/domain/repositories/auth_repository.dart';

class LogInUser {
  const LogInUser(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call(LogInData data) => _repository.logIn(data);
}