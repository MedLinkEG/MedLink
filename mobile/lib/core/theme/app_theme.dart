import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_colors.dart';

abstract final class AppTheme {
  static const buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static final corners = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
      ),

      scaffoldBackgroundColor: AppColors.background,

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.surface,
          minimumSize: const Size(64, 54),
          shape: corners,
          textStyle: buttonText,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          shape: corners,
          textStyle: buttonText,
          minimumSize: const Size(64, 54),
          side: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}
