import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/features/home/domain/user_location.dart';
import 'package:medlink/features/home/presentation/widgets/header_icon_button.dart';
import 'package:medlink/features/home/presentation/widgets/home_search_bar.dart';
import 'package:medlink/features/home/presentation/widgets/location_selector.dart';
import 'package:medlink/shared/widgets/logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.selectedLocation = UserLocation.current,
    this.locations = const [UserLocation.current],
    this.hasUnreadNotifications = false,
    this.onLocationSelected,
    this.onMapTap,
    this.onNotificationsTap,
    this.onSearchTap,
    this.onScanTap,
  });

  final UserLocation selectedLocation;
  final List<UserLocation> locations;
  final bool hasUnreadNotifications;
  final ValueChanged<UserLocation>? onLocationSelected;
  final VoidCallback? onMapTap;
  final VoidCallback? onNotificationsTap;
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
                LocationSelector(
                  selected: selectedLocation,
                  locations: locations,
                  onSelected: onLocationSelected,
                ),
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
