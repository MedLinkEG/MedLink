import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/app.dart';
import 'package:medlink/core/router/app_router.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/core/storage/shared_preferences_provider.dart';
import 'package:medlink/features/home/presentation/home_page.dart';
import 'package:medlink/features/home/presentation/widgets/header_icon_button.dart';
import 'package:medlink/features/notifications/presentation/providers/unread_notifications_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpHome(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    // The app reads the saved language on startup; use an empty store.
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          // Start on the home page instead of the welcome screen.
          appRouterProvider.overrideWith((ref) {
            final router = createAppRouter(initialLocation: AppRoutes.home);
            ref.onDispose(router.dispose);
            return router;
          }),
          ...overrides,
        ],
        child: const MedLinkApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the home page', (tester) async {
    await pumpHome(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('header actions open their pages', (tester) async {
    await pumpHome(tester);

    final actions = {
      find.byTooltip('Map'): 'Map coming soon',
      find.byTooltip('Notifications'): 'Notifications coming soon',
      find.text('Search medicines, devices, pharmacies'): 'Search coming soon',
    };

    for (final entry in actions.entries) {
      await tester.tap(entry.key);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('no notification badge without unread notifications', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.byKey(notificationBadgeKey), findsNothing);
  });

  testWidgets('badge appears when there are unread notifications', (
    tester,
  ) async {
    await pumpHome(
      tester,
      overrides: [unreadNotificationsCountProvider.overrideWithValue(3)],
    );

    expect(find.byKey(notificationBadgeKey), findsOneWidget);
  });
}
