import 'package:medlink/core/storage/token_storage.dart';
import 'package:medlink/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medlink/features/auth/domain/entities/auth_session.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._tokenStorage);

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  @override
  Future<AuthSession> logIn(LogInData data) async {
    final response = await _remote.logIn(data);
    await _tokenStorage.saveAccessToken(response.accessToken);
    return response.toEntity();
  }

  @override
  Future<bool> hasSession() async {
    final token = await _tokenStorage.readAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logOut() => _tokenStorage.clear();
}
