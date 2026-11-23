import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/features/auth/presentation/screens/forgot_password_screen.dart';

import 'forgot_password_test_helpers.dart';

Finder get _continueButton => find.widgetWithText(FilledButton, 'Continue');

void main() {
  testWidgets('shows the title, the email field and Continue', (tester) async {
    await pumpPasswordScreen(
      tester,
      const ForgotPasswordScreen(),
      RecordingPasswordResetRepository(),
    );

    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(_continueButton, findsOneWidget);
  });

  testWidgets('an empty email shows an error and sends nothing', (
    tester,
  ) async {
    final repository = RecordingPasswordResetRepository();
    await pumpPasswordScreen(tester, const ForgotPasswordScreen(), repository);

    await tapVisible(tester, _continueButton);

    expect(find.text('Enter your email'), findsOneWidget);
    expect(repository.requestedEmail, isNull);
  });

  testWidgets('a badly formed email is rejected', (tester) async {
    await pumpPasswordScreen(
      tester,
      const ForgotPasswordScreen(),
      RecordingPasswordResetRepository(),
    );

    await tester.enterText(find.byType(TextFormField), 'nour.adel');
    await tapVisible(tester, _continueButton);

    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('a valid email is sent', (tester) async {
    final repository = RecordingPasswordResetRepository();
    await pumpPasswordScreen(tester, const ForgotPasswordScreen(), repository);

    await tester.enterText(find.byType(TextFormField), 'nour@medlink.com');
    await tapVisible(tester, _continueButton);

    expect(repository.requestedEmail, 'nour@medlink.com');
  });

  testWidgets('no internet shows a message', (tester) async {
    await pumpPasswordScreen(
      tester,
      const ForgotPasswordScreen(),
      RecordingPasswordResetRepository(),
    );

    await tester.enterText(find.byType(TextFormField), 'nour@medlink.com');
    await tapVisible(tester, _continueButton);

    expect(find.text(noInternetMessage), findsOneWidget);
  });
}
