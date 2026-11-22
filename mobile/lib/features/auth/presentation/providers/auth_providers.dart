import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/core/network/dio_provider.dart';
import 'package:medlink/core/storage/token_storage.dart';
import 'package:medlink/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medlink/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:medlink/features/auth/data/repositories/fake_password_reset_repository.dart';
import 'package:medlink/features/auth/domain/repositories/auth_repository.dart';
import 'package:medlink/features/auth/domain/repositories/password_reset_reopsitory.dart';
import 'package:medlink/features/auth/domain/usecases/login_user.dart';
import 'package:medlink/features/auth/domain/usecases/register_user.dart';
import 'package:medlink/features/auth/domain/usecases/request_password_reset.dart';
import 'package:medlink/features/auth/domain/usecases/reset_password.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(dioProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  ),
);

final logInUserProvider = Provider<LogInUser>(
  (ref) => LogInUser(ref.watch(authRepositoryProvider)),
);

final registerUserProvider = Provider<RegisterUser>(
  (ref) => RegisterUser(ref.watch(authRepositoryProvider)),
);

/// Fake for now: change to the real repository when the backend is ready.
final passwordResetRepositoryProvider = Provider<PasswordResetRepository>(
  (ref) => const FakePasswordResetRepository(),
);

final requestPasswordResetProvider = Provider<RequestPasswordReset>(
  (ref) => RequestPasswordReset(ref.watch(passwordResetRepositoryProvider)),
);

final resetPasswordProvider = Provider<ResetPassword>(
  (ref) => ResetPassword(ref.watch(passwordResetRepositoryProvider)),
);
