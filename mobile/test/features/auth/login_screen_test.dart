import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/theme/app_theme.dart';
import 'package:medlink/features/auth/domain/entities/auth_session.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/domain/repositories/auth_repository.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:medlink/features/auth/presentation/screens/login_screen.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.failure = const UnauthorizedFailure()});

  final Failure failure;
  LogInData? received;

  @override
  Future<AuthSession> logIn(LogInData data) async {
    received = data;
    throw failure;
  }

  @override
  Future<bool> hasSession() async => false;

  @override
  Future<void> logOut() async {}
}

Future<void> pumpLogin(
  WidgetTester tester, [
  FakeAuthRepository? repository,
]) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          repository ?? FakeAuthRepository(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const LoginScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder get logInButton => find.widgetWithText(FilledButton, 'Log in');

Future<void> fillForm(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'test@medlink.com');
  await tester.enterText(fields.at(1), '12345678');
}

void main() {
  testWidgets('shows the title, both fields and the Log in button', (
    tester,
  ) async {
    await pumpLogin(tester);

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(logInButton, findsOneWidget);
  });

  testWidgets('empty fields show both error messages', (tester) async {
    final repository = FakeAuthRepository();
    await pumpLogin(tester, repository);

    await tester.tap(logInButton);
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(repository.received, isNull);
  });

  testWidgets('a badly formed email is rejected', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextFormField).first, 'nour.adel');
    await tester.tap(logInButton);
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('the eye button shows and hides the password', (tester) async {
    await pumpLogin(tester);

    final passwordField = find.byType(EditableText).last;
    expect(tester.widget<EditableText>(passwordField).obscureText, isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();

    expect(tester.widget<EditableText>(passwordField).obscureText, isFalse);
  });

  testWidgets('a valid form sends the email and password', (tester) async {
    final repository = FakeAuthRepository();
    await pumpLogin(tester, repository);

    await fillForm(tester);
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    expect(repository.received?.email, 'test@medlink.com');
    expect(repository.received?.password, '12345678');
  });

  testWidgets('wrong email or password shows a message', (tester) async {
    await pumpLogin(tester);

    await fillForm(tester);
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Wrong email or password. Try again or reset your password.'),
      findsOneWidget,
    );
  });

  testWidgets('no internet shows a message', (tester) async {
    await pumpLogin(
      tester,
      FakeAuthRepository(failure: const NetworkFailure()),
    );

    await fillForm(tester);
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Can’t reach MedLink. Check your internet connection and try again.',
      ),
      findsOneWidget,
    );
  });
}
