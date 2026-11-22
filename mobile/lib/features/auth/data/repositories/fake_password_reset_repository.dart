import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';
import 'package:medlink/features/auth/domain/repositories/password_reset_reopsitory.dart';

class FakePasswordResetRepository implements PasswordResetRepository {
  const FakePasswordResetRepository({this.delay = defaultDelay});

  static const defaultDelay = Duration(milliseconds: 800);

  final Duration delay;

  @override
  Future<void> requestReset(String email) => Future<void>.delayed(delay);

  @override
  Future<void> resetPassword(ResetPasswordData data) =>
      Future<void>.delayed(delay);
}