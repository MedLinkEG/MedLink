import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/core/storage/token_storage.dart';
import 'package:medlink/features/auth/data/repositories/auth_repository_impl.dart';

class _FakeTokenStorage implements TokenStorage {
  _FakeTokenStorage([this.token]);

  String? token;

  @override
  Future<void> saveAccessToken(String token) async => this.token = token;

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> clear() async => token = null;
}

void main() {
  test('no saved token means no session', () async {
    final repository = AuthRepositoryImpl(_FakeTokenStorage());

    expect(await repository.hasSession(), isFalse);
  });

  test('a saved token means there is a session', () async {
    final repository = AuthRepositoryImpl(_FakeTokenStorage('abc'));

    expect(await repository.hasSession(), isTrue);
  });

  test('log out forgets the token', () async {
    final storage = _FakeTokenStorage('abc');
    final repository = AuthRepositoryImpl(storage);

    await repository.logOut();

    expect(storage.token, isNull);
    expect(await repository.hasSession(), isFalse);
  });
}
