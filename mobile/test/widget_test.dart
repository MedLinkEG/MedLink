import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/app.dart';
import 'package:medlink/core/storage/shared_preferences_provider.dart';
import 'package:medlink/features/auth/presentation/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(
  WidgetTester tester, {
  Map<String, Object> saved = const {},
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(saved);
  final preferences = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const MedLinkApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('app opens on the welcome screen', (tester) async {
    await pumpApp(tester);
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('language button switches to Arabic and saves it', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('Create account'), findsOneWidget);

    await tester.tap(find.text('عربي'));
    await tester.pumpAndSettle();

    expect(find.text('إنشاء حساب'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('app.language'), 'ar');
  });

  testWidgets('a saved language is used when the app opens', (tester) async {
    await pumpApp(tester, saved: {'app.language': 'ar'});
    expect(find.text('إنشاء حساب'), findsOneWidget);
  });
}
