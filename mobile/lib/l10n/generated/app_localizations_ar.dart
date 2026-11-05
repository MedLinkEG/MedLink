// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ميدلينك';

  @override
  String get welcomeTagline =>
      'ابحث عن الأدوية والأجهزة الطبية القريبة منك، حتى النادرة منها.';

  @override
  String get featureNearby => 'اعرف أي بائع قريب منك يتوفر لديه المنتج';

  @override
  String get featureAlerts => 'احصل على تنبيه عند توفر المنتج الناقص';

  @override
  String get featureVerified => 'اشترِ فقط من بائعين مرخّصين وموثّقين';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get browseAsGuest => 'تصفّح كضيف';

  @override
  String get switchLanguage => 'English';
}
