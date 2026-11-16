import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_colors.dart';


abstract final class AppTextStyles {
  
  static const heroTitle = TextStyle(
    color: AppColors.onBrand,
    fontSize: 34,
    fontWeight: FontWeight.w800,
  );
  static const heroSubtitle = TextStyle(
    color: AppColors.onBrand,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static const screenTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w800,
  );
  static const screenSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
    height: 1.5,
  );

  static const fieldLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  static const bodyStrong = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static const muted = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );
  static const hint = TextStyle(color: AppColors.textSecondary);

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static const link = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}
