import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';

/// Log in screen (UI only): built step by step, one commit per part.
///
/// Nothing is hard-coded here: text comes from the .arb files, colours from
/// AppColors, sizes from AppSpacing / AppRadius / AppSizes, text styles from
/// AppTextStyles, field and button styles from AppTheme.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Shows a back arrow automatically when opened from Welcome.
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      // The content is added in the next commits.
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            0,
            AppSpacing.xxl,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          ),
        ),
      ),
    );
  }
}
