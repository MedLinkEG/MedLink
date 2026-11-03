import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_colors.dart';

const _barRadius = BorderRadius.all(Radius.circular(18));
const _buttonRadius = BorderRadius.all(Radius.circular(12));

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.onSearchTap, this.onScanTap});

  final VoidCallback? onSearchTap;
  final VoidCallback? onScanTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: _barRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.searchShadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onSearchTap,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(18),
                  ),
                  child: const _SearchHint(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: _ScanButton(onTap: onScanTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.textSecondary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search medicines, devices, pharmacies',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Scan prescription',
      child: Ink(
        decoration: const BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: _buttonRadius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: _buttonRadius,
          child: const SizedBox.square(
            dimension: 40,
            child: Icon(Icons.crop_free, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
