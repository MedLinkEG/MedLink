import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/features/home/domain/user_location.dart';

class LocationSelector extends StatelessWidget {
  const LocationSelector({
    required this.selected,
    required this.locations,
    super.key,
    this.onSelected,
  });

  final UserLocation selected;
  final List<UserLocation> locations;
  final ValueChanged<UserLocation>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Material(
        type: MaterialType.transparency,
        child: PopupMenuButton<UserLocation>(
          tooltip: 'Choose location',
          offset: const Offset(0, 40),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          onSelected: onSelected,
          itemBuilder: (context) => [
            for (final location in locations)
              PopupMenuItem(
                value: location,
                child: _LocationMenuItem(
                  location: location,
                  isSelected: location == selected,
                ),
              ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        const TextSpan(text: 'Find near '),
                        TextSpan(
                          text: selected.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationMenuItem extends StatelessWidget {
  const _LocationMenuItem({required this.location, required this.isSelected});

  final UserLocation location;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on_outlined, size: 18, color: AppColors.navy),
        const SizedBox(width: 10),
        Text(
          location.name,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        if (isSelected) ...[
          const SizedBox(width: 10),
          const Icon(Icons.check, size: 18, color: AppColors.teal),
        ],
      ],
    );
  }
}
