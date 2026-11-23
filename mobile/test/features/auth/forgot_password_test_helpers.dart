import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/theme/app_theme.dart';
import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';
import 'package:medlink/features/auth/domain/repositories/password_reset_reopsitory.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

/// Remembers what was sent, then fails with [failure], so the screens show
/// their error message and never try to navigate.
class RecordingPasswordResetRepository implements PasswordResetRepository {
  RecordingPasswordResetRepository({this.failure = const NetworkFailure()});

  final Failure failure;
  String? requestedEmail;
  String? verifiedEmail;
  String? verifiedCode;
  ResetPasswordData? resetData;

  @override
  Future<void> requestReset(String email) async {
    requestedEmail = email;
    throw failure;
  }

  @override
  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    verifiedEmail = email;
    verifiedCode = code;
    throw failure;
  }

  @override
  Future<void> resetPassword(ResetPasswordData data) async {
    resetData = data;
    throw failure;
  }
}

Future<void> pumpPasswordScreen(
  WidgetTester tester,
  Widget screen,
  PasswordResetRepository repository,
) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        passwordResetRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Scrolls [finder] into view, then taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

const noInternetMessage =
    'Can’t reach MedLink. Check your internet connection and try again.';
