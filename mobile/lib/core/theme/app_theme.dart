import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}
