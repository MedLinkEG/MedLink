import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/features/home/presentation/widgets/header_icon_button.dart';
import 'package:medlink/features/home/presentation/widgets/home_search_bar.dart';
import 'package:medlink/features/home/presentation/widgets/location_selector.dart';
import 'package:medlink/shared/widgets/logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.locationLabel = 'Current location',
    this.hasUnreadNotifications = false,
    this.onMapTap,
    this.onNotificationsTap,
    this.onLocationTap,
    this.onSearchTap,
    this.onScanTap,
  });

  final String locationLabel;
  final bool hasUnreadNotifications;
  final VoidCallback? onMapTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onScanTap;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const MedLinkLogo(),
                    const Spacer(),
                    HeaderIconButton(
                      icon: Icons.location_on_outlined,
                      tooltip: 'Map',
                      onTap: onMapTap,
                    ),
                    const SizedBox(width: 10),
                    HeaderIconButton(
                      icon: Icons.notifications_none,
                      tooltip: 'Notifications',
                      showBadge: hasUnreadNotifications,
                      onTap: onNotificationsTap,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LocationSelector(label: locationLabel, onTap: onLocationTap),
                const SizedBox(height: 12),
                HomeSearchBar(onSearchTap: onSearchTap, onScanTap: onScanTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
