import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/features/auth/presentation/screens/reset_password_screen.dart';

import 'forgot_password_test_helpers.dart';

const _screen = ResetPasswordScreen(resetToken: 'token-123');

Finder get _saveButton => find.widgetWithText(FilledButton, 'Save password');

Future<void> _fill(
  WidgetTester tester, {
  required String password,
  required String confirm,
}) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), password);
  await tester.enterText(fields.at(1), confirm);
}

void main() {
  testWidgets('shows the title, two password fields and Save', (
    tester,
  ) async {
    await pumpPasswordScreen(
      tester,
      _screen,
      RecordingPasswordResetRepository(),
    );

    expect(find.text('Set a new password'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(_saveButton, findsOneWidget);
  });

  testWidgets('empty fields show both errors and send nothing', (
    tester,
  ) async {
    final repository = RecordingPasswordResetRepository();
    await pumpPasswordScreen(tester, _screen, repository);

    await tapVisible(tester, _saveButton);

    expect(find.text('Enter your password'), findsOneWidget);
    expect(find.text('Enter the password again'), findsOneWidget);
    expect(repository.resetData, isNull);
  });

  testWidgets('a short password is rejected', (tester) async {
    await pumpPasswordScreen(
      tester,
      _screen,
      RecordingPasswordResetRepository(),
    );

    await _fill(tester, password: '1234', confirm: '1234');
    await tapVisible(tester, _saveButton);

    expect(find.text('Use at least 8 characters'), findsOneWidget);
  });

  testWidgets('different passwords are rejected', (tester) async {
    final repository = RecordingPasswordResetRepository();
    await pumpPasswordScreen(tester, _screen, repository);

    await _fill(tester, password: '12345678', confirm: '87654321');
    await tapVisible(tester, _saveButton);

    expect(find.text('Passwords don’t match'), findsOneWidget);
    expect(repository.resetData, isNull);
  });

  testWidgets('matching passwords are sent with the token', (tester) async {
    final repository = RecordingPasswordResetRepository();
    await pumpPasswordScreen(tester, _screen, repository);

    await _fill(tester, password: '12345678', confirm: '12345678');
    await tapVisible(tester, _saveButton);

    expect(repository.resetData?.resetToken, 'token-123');
    expect(repository.resetData?.newPassword, '12345678');
    expect(find.text(noInternetMessage), findsOneWidget);
  });
}
