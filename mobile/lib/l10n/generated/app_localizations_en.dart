// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MedLink';

  @override
  String get welcomeTagline =>
      'Find medicines and medical devices near you, even when they’re hard to find.';

  @override
  String get featureNearby => 'See which nearby sellers have each item';

  @override
  String get featureAlerts => 'Get alerted when a missing item is back';

  @override
  String get featureVerified => 'Buy only from license-verified sellers';

  @override
  String get createAccount => 'Create account';

  @override
  String get logIn => 'Log in';

  @override
  String get browseAsGuest => 'Browse as guest';

  @override
  String get switchLanguage => 'عربي';
}
