import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/core/l10n/locale_provider.dart';
import 'package:medlink/core/router/app_router.dart';
import 'package:medlink/core/theme/app_theme.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class MedLinkApp extends ConsumerWidget {
  const MedLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
