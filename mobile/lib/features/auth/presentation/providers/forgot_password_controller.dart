import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';

final forgotPasswordControllerProvider =
    AsyncNotifierProvider.autoDispose<ForgotPasswordController, void>(
      ForgotPasswordController.new,
    );

class ForgotPasswordController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> requestReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(requestPasswordResetProvider)(email),
    );
  }
}
