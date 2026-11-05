import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/app.dart';
import 'package:medlink/features/auth/presentation/screens/welcome_screen.dart';

/// Makes the test screen the size of a phone (390 x 844), like an iPhone 14.
/// The default test screen is 800 x 600 landscape, which is too short.
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('app opens on the welcome screen', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ProviderScope(child: MedLinkApp()));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('language button switches the welcome screen to Arabic', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ProviderScope(child: MedLinkApp()));
    await tester.pumpAndSettle();
    expect(find.text('Create account'), findsOneWidget);

    await tester.tap(find.text('عربي'));
    await tester.pumpAndSettle();

    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });
}
