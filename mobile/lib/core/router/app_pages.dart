import 'package:get/get.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/features/auth/presentation/screens/login_screen.dart';
import 'package:medlink/features/auth/presentation/screens/welcome_screen.dart';

abstract final class AppPages {
  static final List<GetPage<void>> pages = [
    GetPage<void>(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage<void>(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}