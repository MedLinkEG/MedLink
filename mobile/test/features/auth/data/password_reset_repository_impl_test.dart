import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/features/auth/data/datasources/password_reset_remote_data_source.dart';
import 'package:medlink/features/auth/data/repositories/password_reset_repository_impl.dart';
import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';

class _FakeRemote implements PasswordResetRemoteDataSource {
  final calls = <String>[];

  @override
  Future<void> requestReset(String email) async => calls.add('code $email');

  @override
  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    calls.add('verify $email $code');
    return 'token-123';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async => calls.add('reset $resetToken $newPassword');
}

void main() {
  late _FakeRemote remote;
  late PasswordResetRepositoryImpl repository;

  setUp(() {
    remote = _FakeRemote();
    repository = PasswordResetRepositoryImpl(remote);
  });

  test('asks the backend to email a code', () async {
    await repository.requestReset('a@b.com');

    expect(remote.calls, ['code a@b.com']);
  });

  test('checking the code returns the reset token', () async {
    final token = await repository.verifyCode(email: 'a@b.com', code: '123456');

    expect(token, 'token-123');
    expect(remote.calls, ['verify a@b.com 123456']);
  });

  test('saves the new password with the reset token', () async {
    await repository.resetPassword(
      const ResetPasswordData(resetToken: 'token-123', newPassword: '12345678'),
    );

    expect(remote.calls, ['reset token-123 12345678']);
  });
}
