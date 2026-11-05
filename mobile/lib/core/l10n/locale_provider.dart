import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  /// Switches between English and Arabic.
  void toggle() {
    state = state.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
  }
}
