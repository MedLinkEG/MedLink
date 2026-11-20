import 'package:medlink/features/auth/domain/entities/auth_session.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/domain/entities/register_data.dart';

abstract interface class AuthRepository {
  Future<AuthSession> logIn(LogInData data);

  Future<AuthSession> register(RegisterData data);

  Future<bool> hasSession();

  Future<void> logOut();
}
