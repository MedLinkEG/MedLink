import 'package:flutter/material.dart';
import 'package:medlink/core/constants/app_assets.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/features/home/domain/home_category.dart';

const _tileRadius = BorderRadius.all(Radius.circular(14));
const _iconAreaHeight = 40.0;

const _shortcuts = [
  _Shortcut(
    category: HomeCategory.pharmacies,
    label: 'Pharmacies',
    icon: Icons.local_pharmacy_outlined,
    asset: AppAssets.pharmacyIcon,
  ),
  _Shortcut(
    category: HomeCategory.sellerOffers,
    label: 'Seller Offers',
    icon: Icons.local_offer_outlined,
    asset: AppAssets.sellerOffersIcon,
  ),
  _Shortcut(
    category: HomeCategory.prescriptionScan,
    label: 'Prescription Scan',
    icon: Icons.document_scanner_outlined,
    asset: AppAssets.prescriptionScanIcon,
  ),
  _Shortcut(
    category: HomeCategory.orders,
    label: 'Orders',
    icon: Icons.chat_bubble_outline,
    asset: AppAssets.ordersIcon,
  ),
  _Shortcut(
    category: HomeCategory.notifyMe,
    label: 'Notify Me',
    icon: Icons.notifications_none,
    asset: AppAssets.snotifyMeIcon,
  ),
  _Shortcut(
    category: HomeCategory.favorites,
    label: 'Favorites',
    icon: Icons.favorite_border,
    asset: AppAssets.favoritesIcon,
  ),
];

class CategoryShortcuts extends StatelessWidget {
  const CategoryShortcuts({super.key, this.onTap});

  final ValueChanged<HomeCategory>? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.34,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final shortcut in _shortcuts)
            _ShortcutTile(
              shortcut: shortcut,
              onTap: () => onTap?.call(shortcut.category),
            ),
        ],
      ),
    );
  }
}

class _Shortcut {
  const _Shortcut({
    required this.category,
    required this.label,
    required this.icon,
    this.asset,
  });

  final HomeCategory category;
  final String label;
  final IconData icon;
  final String? asset;
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({required this.shortcut, required this.onTap});

  final _Shortcut shortcut;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.tileStart, AppColors.tileEnd],
          ),
          borderRadius: _tileRadius,
        ),
        child: InkWell(
          borderRadius: _tileRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: _iconAreaHeight,
                  child: Center(
                    child: _ShortcutIcon(
                      icon: shortcut.icon,
                      asset: shortcut.asset,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    shortcut.label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortcutIcon extends StatelessWidget {
  const _ShortcutIcon({required this.icon, this.asset});

  final IconData icon;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(icon, size: 28, color: AppColors.navy);
    final path = asset;
    if (path == null) return fallback;

    return Image.asset(
      path,
      height: _iconAreaHeight,
      excludeFromSemantics: true,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}
