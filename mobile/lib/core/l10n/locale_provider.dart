import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medlink/core/storage/shared_preferences_provider.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  static const _savedLanguageKey = 'app.language';
  static const english = Locale('en');
  static const arabic = Locale('ar');

  @override
  Locale build() {
    final saved = ref
        .watch(sharedPreferencesProvider)
        .getString(_savedLanguageKey);
    if (saved != null) return Locale(saved);

    final phoneLanguage = PlatformDispatcher.instance.locale.languageCode;
    return phoneLanguage == 'ar' ? arabic : english;
  }

  void setLocale(Locale locale) {
    state = locale;
    unawaited(
      ref
          .read(sharedPreferencesProvider)
          .setString(_savedLanguageKey, locale.languageCode),
    );
  }

  void toggle() => setLocale(state == arabic ? english : arabic);
}
