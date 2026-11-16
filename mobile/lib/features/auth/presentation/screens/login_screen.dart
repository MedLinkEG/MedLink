import 'package:flutter/material.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            0,
            AppSpacing.xxl,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: _LogoTile(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.loginTitle, style: AppTextStyles.screenTitle),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.loginSubtitle, style: AppTextStyles.screenSubtitle),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoTile extends StatelessWidget {
  const _LogoTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.logoTile,
      height: AppSizes.logoTile,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: AppColors.brandGradient,
      ),
      child: const Icon(
        AppIcons.add,
        color: AppColors.onBrand,
        size: AppSizes.iconLg,
      ),
    );
  }
}
