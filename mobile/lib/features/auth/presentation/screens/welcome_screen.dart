import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/l10n/locale_provider.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    gradient: AppColors.brandGradient,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: _LanguageButton(
                          label: l10n.switchLanguage,
                          onPressed: () =>
                              ref.read(localeProvider.notifier).toggle(),
                        ),
                      ),
                      const Spacer(),
                      Text(l10n.appName, style: AppTextStyles.heroTitle),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.welcomeTagline,
                        style: AppTextStyles.heroSubtitle,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
              _FeatureRow(icon: AppIcons.search, text: l10n.featureNearby),
              _FeatureRow(
                icon: AppIcons.notifications,
                text: l10n.featureAlerts,
              ),
              _FeatureRow(icon: AppIcons.verified, text: l10n.featureVerified),
              const SizedBox(height: AppSpacing.xl),

              FilledButton(
                onPressed: () => context.push(AppRoutes.register),
                child: Text(l10n.createAccount),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.push(AppRoutes.login),
                child: Text(l10n.logIn),
              ),
              TextButton(onPressed: () {}, child: Text(l10n.browseAsGuest)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(AppIcons.language, size: AppSizes.iconSm),
      label: Text(label),
      // White on the card instead of the theme's navy.
      style: TextButton.styleFrom(
        foregroundColor: AppColors.onBrand,
        backgroundColor: AppColors.glassFill,
        side: const BorderSide(color: AppColors.glassBorder),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.featureTile,
            height: AppSizes.featureTile,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              gradient: const LinearGradient(
                colors: [AppColors.tileStart, AppColors.tileEnd],
              ),
            ),
            child: Icon(icon, size: AppSizes.iconMd, color: AppColors.teal),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: AppTextStyles.bodyStrong)),
        ],
      ),
    );
  }
}
