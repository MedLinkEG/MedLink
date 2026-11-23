import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';

final AsyncNotifierProvider<ResetPasswordController, void>
resetPasswordControllerProvider =
    AsyncNotifierProvider.autoDispose<ResetPasswordController, void>(
      ResetPasswordController.new,
    );

class ResetPasswordController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> resetPassword(ResetPasswordData data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(resetPasswordProvider)(data));
  }
}
