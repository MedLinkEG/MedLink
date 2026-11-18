import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';


final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(
  LoginController.new,
);

class LoginController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> logIn(LogInData data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(logInUserProvider)(data));
  }
}