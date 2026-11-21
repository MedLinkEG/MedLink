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

  @override
  String get loginTitle => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle =>
      'سجّل الدخول لترى تنبيهاتك ومحادثاتك وعمليات البحث المحفوظة.';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get orDivider => 'أو';

  @override
  String get unlockWithFingerprint => 'الدخول ببصمة الإصبع';

  @override
  String get newToMedLink => 'جديد على ميدلينك؟';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get emailRequired => 'أدخل بريدك الإلكتروني';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get passwordRequired => 'أدخل كلمة المرور';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة. حاول مرة أخرى أو أعد تعيين كلمة المرور.';

  @override
  String get errorInvalidData =>
      'لم يتم قبول بعض البيانات. راجعها وحاول مرة أخرى.';

  @override
  String get errorNetwork =>
      'تعذّر الاتصال بميدلينك. تحقّق من الإنترنت وحاول مرة أخرى.';

  @override
  String get errorServer => 'حدث خطأ من جهتنا. حاول مرة أخرى بعد قليل.';

  @override
  String get errorUnknown => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get registerTitle => 'أنشئ حسابك';

  @override
  String get registerSubtitle =>
      'دقيقة واحدة وتكون جاهزًا. ستستخدم بريدك الإلكتروني لتسجيل الدخول.';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get fullNameHint => 'محمد باسل';

  @override
  String get fullNameRequired => 'أدخل اسمك الكامل';

  @override
  String get phoneLabel => 'رقم الموبايل';

  @override
  String get phoneHint => '01012345678';

  @override
  String get phoneRequired => 'أدخل رقم الموبايل';

  @override
  String get phoneInvalid =>
      'أدخل رقمًا مصريًا يبدأ بـ 010 أو 011 أو 012 أو 015';

  @override
  String get createPasswordLabel => 'أنشئ كلمة مرور';

  @override
  String passwordRule(int min) {
    return '$min أحرف على الأقل';
  }

  @override
  String passwordTooShort(int min) {
    return 'استخدم $min أحرف على الأقل';
  }

  @override
  String passwordTooLong(int max) {
    return 'استخدم $max حرفًا أو أقل';
  }

  @override
  String get agreeTerms => 'أوافق على شروط الخدمة وسياسة الخصوصية.';

  @override
  String get termsRequired => 'وافق على الشروط للمتابعة';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get errorEmailTaken =>
      'يوجد حساب بهذا البريد الإلكتروني بالفعل. سجّل الدخول بدلًا من ذلك.';

  @override
  String get accountCreated => 'تم إنشاء الحساب. سجّل الدخول للمتابعة.';
}
