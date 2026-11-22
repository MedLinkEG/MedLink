import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/features/home/data/hero_banner_slides.dart';
import 'package:medlink/features/home/presentation/providers/location_providers.dart';
import 'package:medlink/features/home/presentation/widgets/category_shortcuts.dart';
import 'package:medlink/features/home/presentation/widgets/hero_banner.dart';
import 'package:medlink/features/home/presentation/widgets/home_header.dart';
import 'package:medlink/features/notifications/presentation/providers/unread_notifications_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final locations = ref.watch(savedLocationsProvider);
    final hasUnread = ref.watch(unreadNotificationsCountProvider) > 0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeader(
              selectedLocation: selectedLocation,
              locations: locations,
              hasUnreadNotifications: hasUnread,
              onLocationSelected: ref
                  .read(selectedLocationProvider.notifier)
                  .select,
              onMapTap: () => context.push(AppRoutes.map),
              onNotificationsTap: () => context.push(AppRoutes.notifications),
              onSearchTap: () => context.push(AppRoutes.search),
            ),
            const SizedBox(height: 16),
            const CategoryShortcuts(),
            const SizedBox(height: 16),
            const HeroBanner(slides: heroBannerSlides),
          ],
        ),
      ),
    );
  }
}
