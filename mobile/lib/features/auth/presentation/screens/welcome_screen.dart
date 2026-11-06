import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/l10n/locale_provider.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

/// Welcome screen: gradient card with a language button, three feature
/// lines, and three buttons. Button styles come from AppTheme, text from
/// the .arb files in lib/l10n.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Gradient card: takes the space left over.
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
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
                      Text(
                        l10n.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.welcomeTagline,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Feature lines.
              const SizedBox(height: 20),
              _FeatureRow(icon: AppIcons.search, text: l10n.featureNearby),
              _FeatureRow(
                icon: AppIcons.notifications,
                text: l10n.featureAlerts,
              ),
              _FeatureRow(icon: AppIcons.verified, text: l10n.featureVerified),
              const SizedBox(height: 20),

              // 3. Buttons.
              FilledButton(onPressed: () {}, child: Text(l10n.createAccount)),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: () {}, child: Text(l10n.logIn)),
              TextButton(onPressed: () {}, child: Text(l10n.browseAsGuest)),
            ],
          ),
        ),
      ),
    );
  }
}

/// The small see-through button on the gradient card: "عربي" / "English".
class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(AppIcons.language, size: 18),
      label: Text(label),
      // White on the card instead of the theme's navy.
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.glassFill,
        side: const BorderSide(color: AppColors.glassBorder),
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
    );
  }
}

/// One feature line: an icon in a soft tile, then the text.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [AppColors.tileStart, AppColors.tileEnd],
              ),
            ),
            child: Icon(icon, size: 20, color: AppColors.teal),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
