import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/storage/token_storage.dart';
import 'package:medlink/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medlink/features/auth/data/models/auth_response_model.dart';
import 'package:medlink/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/domain/entities/register_data.dart';

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

/// A pretend backend: answers with a token, or throws [failure].
class _FakeRemote implements AuthRemoteDataSource {
  _FakeRemote({this.failure});

  final Failure? failure;

  @override
  Future<AuthResponseModel> logIn(LogInData data) async {
    final failure = this.failure;
    if (failure != null) throw failure;
    return const AuthResponseModel(accessToken: 'new', tokenType: 'Bearer');
  }

  @override
  Future<AuthResponseModel> register(RegisterData data) async {
    final failure = this.failure;
    if (failure != null) throw failure;
    return const AuthResponseModel(accessToken: 'new', tokenType: 'Bearer');
  }

  @override
  Future<AuthResponseModel> postForSession(
    String path,
    Map<String, dynamic> body,
  ) {
    throw UnimplementedError();
  }
}

const _credentials = LogInData(email: 'a@b.com', password: '12345678');

void main() {
  test('no saved token means no session', () async {
    final repository = AuthRepositoryImpl(_FakeRemote(), _FakeTokenStorage());

    expect(await repository.hasSession(), isFalse);
  });

  test('a saved token means there is a session', () async {
    final repository = AuthRepositoryImpl(
      _FakeRemote(),
      _FakeTokenStorage('abc'),
    );

    expect(await repository.hasSession(), isTrue);
  });

  test('log out forgets the token', () async {
    final storage = _FakeTokenStorage('abc');
    final repository = AuthRepositoryImpl(_FakeRemote(), storage);

    await repository.logOut();

    expect(storage.token, isNull);
    expect(await repository.hasSession(), isFalse);
  });

  test('log in saves the token and returns the session', () async {
    final storage = _FakeTokenStorage();
    final repository = AuthRepositoryImpl(_FakeRemote(), storage);

    final session = await repository.logIn(_credentials);

    expect(session.accessToken, 'new');
    expect(storage.token, 'new');
  });

  test('a failed log in saves nothing', () async {
    final storage = _FakeTokenStorage();
    final repository = AuthRepositoryImpl(
      _FakeRemote(failure: const UnauthorizedFailure()),
      storage,
    );

    await expectLater(
      repository.logIn(_credentials),
      throwsA(isA<UnauthorizedFailure>()),
    );
    expect(storage.token, isNull);
  });
}
