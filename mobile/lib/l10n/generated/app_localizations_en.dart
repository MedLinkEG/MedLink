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

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle =>
      'Log in to see your alerts, chats and saved searches.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get orDivider => 'or';

  @override
  String get unlockWithFingerprint => 'Unlock with fingerprint';

  @override
  String get newToMedLink => 'New to MedLink?';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get errorInvalidCredentials =>
      'Wrong email or password. Try again or reset your password.';

  @override
  String get errorInvalidData =>
      'Some details weren’t accepted. Check them and try again.';

  @override
  String get errorNetwork =>
      'Can’t reach MedLink. Check your internet connection and try again.';

  @override
  String get errorServer =>
      'Something went wrong on our side. Please try again in a moment.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle =>
      'It only takes a minute. You’ll use your email to log in.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'Mohamed Bassel';

  @override
  String get fullNameRequired => 'Enter your full name';

  @override
  String get phoneLabel => 'Mobile number';

  @override
  String get phoneHint => '01012345678';

  @override
  String get phoneRequired => 'Enter your mobile number';

  @override
  String get phoneInvalid =>
      'Enter an Egyptian number starting with 010, 011, 012 or 015';

  @override
  String get createPasswordLabel => 'Create a password';

  @override
  String passwordRule(int min) {
    return 'At least $min characters';
  }

  @override
  String passwordTooShort(int min) {
    return 'Use at least $min characters';
  }

  @override
  String passwordTooLong(int max) {
    return 'Use $max characters or fewer';
  }

  @override
  String get agreeTerms =>
      'I agree to the Terms of Service and Privacy Policy.';

  @override
  String get termsRequired => 'Accept the terms to continue';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get errorEmailTaken =>
      'An account with this email already exists. Log in instead.';

  @override
  String get accountCreated => 'Account created. Log in to continue.';
}
