import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';

/// Holds the reset token once the code is right; null before that.
final AsyncNotifierProvider<VerifyCodeController, String?>
verifyCodeControllerProvider =
    AsyncNotifierProvider.autoDispose<VerifyCodeController, String?>(
      VerifyCodeController.new,
    );

class VerifyCodeController extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() => null;

  Future<void> verify({required String email, required String code}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(verifyResetCodeProvider)(email: email, code: code),
    );
  }
}
