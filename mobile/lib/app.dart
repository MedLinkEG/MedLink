import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/core/l10n/locale_provider.dart';
import 'package:medlink/core/theme/app_theme.dart';
import 'package:medlink/features/auth/presentation/screens/welcome_screen.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class MedLinkApp extends ConsumerWidget {
  const MedLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MedLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // When this changes, the whole app rebuilds in the new language.
      // Arabic switches to right-to-left automatically.
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const WelcomeScreen(),
    );
  }
}
