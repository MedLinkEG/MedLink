import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/features/auth/domain/entities/register_data.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, void>(RegisterController.new);

class RegisterController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> register(RegisterData data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(registerUserProvider)(data));
  }
}
