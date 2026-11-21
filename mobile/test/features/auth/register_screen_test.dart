import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/theme/app_theme.dart';
import 'package:medlink/features/auth/domain/entities/auth_session.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/domain/entities/register_data.dart';
import 'package:medlink/features/auth/domain/repositories/auth_repository.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:medlink/features/auth/presentation/screens/register_screen.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.failure = const ConflictFailure()});

  final Failure failure;
  RegisterData? received;

  @override
  Future<AuthSession> register(RegisterData data) async {
    received = data;
    throw failure;
  }

  @override
  Future<AuthSession> logIn(LogInData data) async => throw failure;

  @override
  Future<bool> hasSession() async => false;

  @override
  Future<void> logOut() async {}
}

/// Shows the Create account screen on a phone-sized screen, in English.
Future<void> _pumpRegister(
  WidgetTester tester, [
  _FakeAuthRepository? repository,
]) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          repository ?? _FakeAuthRepository(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const RegisterScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder get _createAccountButton =>
    find.widgetWithText(FilledButton, 'Create account');

/// Scrolls [finder] into view first, because the form is taller than the
/// screen.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _fillForm(
  WidgetTester tester, {
  String phone = '01012345678',
  String password = '12345678',
}) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'Nour Adel');
  await tester.enterText(fields.at(1), 'nour@medlink.com');
  await tester.enterText(fields.at(2), phone);
  await tester.enterText(fields.at(3), password);
}

void main() {
  testWidgets('shows the title, four fields and the button', (tester) async {
    await _pumpRegister(tester);

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(_createAccountButton, findsOneWidget);
  });

  testWidgets('an empty form shows every error and sends nothing', (
    tester,
  ) async {
    final repository = _FakeAuthRepository();
    await _pumpRegister(tester, repository);

    await _tap(tester, _createAccountButton);

    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your mobile number'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(find.text('Accept the terms to continue'), findsOneWidget);
    expect(repository.received, isNull);
  });

  testWidgets('a non-Egyptian mobile number is rejected', (tester) async {
    await _pumpRegister(tester);

    await _fillForm(tester, phone: '0191234');
    await _tap(tester, _createAccountButton);

    expect(
      find.text('Enter an Egyptian number starting with 010, 011, 012 or 015'),
      findsOneWidget,
    );
  });

  testWidgets('a short password is rejected', (tester) async {
    await _pumpRegister(tester);

    await _fillForm(tester, password: '1234');
    await _tap(tester, _createAccountButton);

    expect(find.text('Use at least 8 characters'), findsOneWidget);
  });

  testWidgets('a valid form sends every field', (tester) async {
    final repository = _FakeAuthRepository();
    await _pumpRegister(tester, repository);

    await _fillForm(tester);
    await _tap(tester, find.byType(Checkbox));
    await _tap(tester, _createAccountButton);

    expect(repository.received?.fullName, 'Nour Adel');
    expect(repository.received?.email, 'nour@medlink.com');
    expect(repository.received?.phone, '01012345678');
    expect(repository.received?.password, '12345678');
  });

  testWidgets('an email that is already used shows a message', (tester) async {
    await _pumpRegister(tester);

    await _fillForm(tester);
    await _tap(tester, find.byType(Checkbox));
    await _tap(tester, _createAccountButton);

    expect(
      find.text('An account with this email already exists. Log in instead.'),
      findsOneWidget,
    );
  });

  testWidgets('no internet shows a message', (tester) async {
    await _pumpRegister(
      tester,
      _FakeAuthRepository(failure: const NetworkFailure()),
    );

    await _fillForm(tester);
    await _tap(tester, find.byType(Checkbox));
    await _tap(tester, _createAccountButton);

    expect(
      find.text(
        'Can’t reach MedLink. Check your internet connection and try again.',
      ),
      findsOneWidget,
    );
  });
}
