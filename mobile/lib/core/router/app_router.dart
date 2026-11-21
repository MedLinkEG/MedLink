import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/features/auth/presentation/screens/login_screen.dart';
import 'package:medlink/features/auth/presentation/screens/welcome_screen.dart';
import 'package:medlink/features/home/presentation/home_page.dart';
import 'package:medlink/shared/widgets/placeholder_page.dart';

GoRouter createAppRouter({String initialLocation = AppRoutes.welcome}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, _) => const WelcomeScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
      GoRoute(
        path: AppRoutes.map,
        builder: (_, _) => const PlaceholderPage(title: 'Map'),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => const PlaceholderPage(title: 'Notifications'),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (_, _) => const PlaceholderPage(title: 'Search'),
      ),
    ],
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter();
  ref.onDispose(router.dispose);
  return router;
});
