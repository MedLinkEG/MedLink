import 'package:flutter/material.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';
import 'package:medlink/core/utils/validators.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
  }

  String? _validateEmail(String? value, AppLocalizations l10n) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return l10n.emailRequired;
    if (!Validators.isEmail(email)) return l10n.emailInvalid;
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.passwordRequired;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            0,
            AppSpacing.xxl,
            AppSpacing.xxl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header.
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _LogoTile(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.loginTitle, style: AppTextStyles.screenTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.loginSubtitle, style: AppTextStyles.screenSubtitle),
                const SizedBox(height: AppSpacing.xxxl),

                // 2. Email.
                _FieldLabel(l10n.emailLabel),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: l10n.emailHint,
                    prefixIcon: const Icon(AppIcons.email),
                  ),
                  validator: (value) => _validateEmail(value, l10n),
                ),
                const SizedBox(height: AppSpacing.xl),

                Row(
                  children: [
                    Expanded(child: _FieldLabel(l10n.passwordLabel)),
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.forgotPassword),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _logIn(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(AppIcons.lock),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _hidePassword = !_hidePassword),
                      tooltip: _hidePassword
                          ? l10n.showPassword
                          : l10n.hidePassword,
                      icon: Icon(
                        _hidePassword
                            ? AppIcons.showPassword
                            : AppIcons.hidePassword,
                      ),
                    ),
                  ),
                  validator: (value) => _validatePassword(value, l10n),
                ),
                const SizedBox(height: AppSpacing.xxl),

                FilledButton(onPressed: _logIn, child: Text(l10n.logIn)),
                const SizedBox(height: AppSpacing.lg),

                // 5. "or" line and fingerprint unlock.
                _OrDivider(label: l10n.orDivider),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(AppIcons.fingerprint),
                  label: Text(l10n.unlockWithFingerprint),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // 6. Link to sign up.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.newToMedLink, style: AppTextStyles.muted),
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.createAccount),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoTile extends StatelessWidget {
  const _LogoTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.logoTile,
      height: AppSizes.logoTile,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: AppColors.brandGradient,
      ),
      child: const Icon(
        AppIcons.add,
        color: AppColors.onBrand,
        size: AppSizes.iconLg,
      ),
    );
  }
}

/// Bold label above a field.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.fieldLabel),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(label, style: AppTextStyles.muted),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
