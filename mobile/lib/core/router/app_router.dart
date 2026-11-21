import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/features/auth/presentation/screens/login_screen.dart';
import 'package:medlink/features/auth/presentation/screens/register_screen.dart';
import 'package:medlink/features/auth/presentation/screens/welcome_screen.dart';
import 'package:medlink/features/home/presentation/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.welcome,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, _) => const WelcomeScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
