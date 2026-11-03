import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_colors.dart';

const double _buttonSize = 44;

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    required this.icon,
    required this.tooltip,
    super.key,
    this.showBadge = false,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool showBadge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.glassFill,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.glassBorder),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(
            dimension: _buttonSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                if (showBadge)
                  const Positioned(top: 10, right: 11, child: _Badge()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.notificationDot,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.notificationDotBorder, width: 1.5),
        ),
      ),
      child: SizedBox.square(dimension: 10),
    );
  }
}
