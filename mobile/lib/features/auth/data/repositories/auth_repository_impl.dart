import 'package:medlink/core/storage/token_storage.dart';
import 'package:medlink/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<bool> hasSession() async {
    final token = await _tokenStorage.readAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logOut() => _tokenStorage.clear();
}
