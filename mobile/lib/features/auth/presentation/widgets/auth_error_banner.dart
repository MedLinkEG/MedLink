import 'package:flutter/material.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            AppIcons.error,
            color: AppColors.error,
            size: AppSizes.iconMd,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message, style: AppTextStyles.error)),
        ],
      ),
    );
  }
}
