import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/features/auth/presentation/screens/verify_reset_code_screen.dart';

import 'forgot_password_test_helpers.dart';

const _screen = VerifyResetCodeScreen(email: 'nour@medlink.com');

Finder get _verifyButton => find.widgetWithText(FilledButton, 'Verify');

void main() {
  testWidgets('shows the title, the email and the code field', (tester) async {
    await pumpPasswordScreen(
      tester,
      _screen,
      RecordingPasswordResetRepository(),
    );

    expect(find.text('Check your email'), findsOneWidget);
    expect(find.textContaining('nour@medlink.com'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(_verifyButton, findsOneWidget);
  });

  testWidgets('typed digits show one per box', (tester) async {
    await pumpPasswordScreen(
      tester,
      _screen,
      RecordingPasswordResetRepository(),
    );

    await tester.enterText(find.byType(TextFormField), '25');
    await tester.pump();

    expect(find.text('2'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('an empty code shows an error and sends nothing', (tester) async {
    final repository = RecordingPasswordResetRepository();
    await pumpPasswordScreen(tester, _screen, repository);

    await tapVisible(tester, _verifyButton);

    expect(find.text('Enter the code from the email'), findsOneWidget);
    expect(repository.verifiedCode, isNull);
  });

  testWidgets('a short code is rejected', (tester) async {
    await pumpPasswordScreen(
      tester,
      _screen,
      RecordingPasswordResetRepository(),
    );

    await tester.enterText(find.byType(TextFormField), '123');
    await tapVisible(tester, _verifyButton);

    expect(find.text('Enter all 6 digits'), findsOneWidget);
  });

  testWidgets('a full code is sent with the email', (tester) async {
    final repository = RecordingPasswordResetRepository();
    await pumpPasswordScreen(tester, _screen, repository);

    await tester.enterText(find.byType(TextFormField), '255525');
    await tapVisible(tester, _verifyButton);

    expect(repository.verifiedEmail, 'nour@medlink.com');
    expect(repository.verifiedCode, '255525');
    expect(find.text(noInternetMessage), findsOneWidget);
  });

  testWidgets('a wrong code shows a message', (tester) async {
    await pumpPasswordScreen(
      tester,
      _screen,
      RecordingPasswordResetRepository(failure: const InvalidDataFailure()),
    );

    await tester.enterText(find.byType(TextFormField), '000000');
    await tapVisible(tester, _verifyButton);

    expect(
      find.text(
        'That code is wrong or has expired. Check it or resend a new one.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Resend code asks for a new code', (tester) async {
    final repository = RecordingPasswordResetRepository();
    await pumpPasswordScreen(tester, _screen, repository);

    await tapVisible(tester, find.text('Resend code'));

    expect(repository.requestedEmail, 'nour@medlink.com');

    // Let the message at the bottom time out before the test ends.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
