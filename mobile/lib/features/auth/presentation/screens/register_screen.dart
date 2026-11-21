import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';
import 'package:medlink/core/utils/validators.dart';
import 'package:medlink/features/auth/domain/entities/register_data.dart';
import 'package:medlink/features/auth/presentation/providers/register_controller.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_field_label.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

/// Create account: full name, email, mobile number, password and the
/// Terms checkbox. Sends them to POST /api/auth/register; on success the
/// user goes to Log in with the email already filled in.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    await ref
        .read(registerControllerProvider.notifier)
        .register(
          RegisterData(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  String _messageFor(Object? error, AppLocalizations l10n) {
    return switch (error) {
      ConflictFailure() => l10n.errorEmailTaken,
      InvalidDataFailure() => l10n.errorInvalidData,
      NetworkFailure() => l10n.errorNetwork,
      ServerFailure() => l10n.errorServer,
      _ => l10n.errorUnknown,
    };
  }

  String? _validateName(String? value, AppLocalizations l10n) {
    if ((value ?? '').trim().isEmpty) return l10n.fullNameRequired;
    return null;
  }

  String? _validateEmail(String? value, AppLocalizations l10n) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return l10n.emailRequired;
    if (!Validators.isEmail(email)) return l10n.emailInvalid;
    return null;
  }

  String? _validatePhone(String? value, AppLocalizations l10n) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return l10n.phoneRequired;
    if (!Validators.isEgyptianPhone(phone)) return l10n.phoneInvalid;
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations l10n) {
    final password = value ?? '';
    if (password.isEmpty) return l10n.passwordRequired;
    if (password.length < Validators.minPasswordLength) {
      return l10n.passwordTooShort(Validators.minPasswordLength);
    }
    if (password.length > Validators.maxPasswordLength) {
      return l10n.passwordTooLong(Validators.maxPasswordLength);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final registerState = ref.watch(registerControllerProvider);
    final isLoading = registerState.isLoading;

    ref.listen(registerControllerProvider, (previous, next) {
      final finished = previous?.isLoading == true && next.hasValue;
      if (finished && !next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.accountCreated)));
        // Log in next, with the new email already filled in.
        context.pushReplacement(
          AppRoutes.login,
          extra: _emailController.text.trim(),
        );
      }
    });

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
                Text(l10n.registerTitle, style: AppTextStyles.screenTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.registerSubtitle,
                  style: AppTextStyles.screenSubtitle,
                ),
                const SizedBox(height: AppSpacing.xxl),

                AuthFieldLabel(l10n.fullNameLabel),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  decoration: InputDecoration(
                    hintText: l10n.fullNameHint,
                    prefixIcon: const Icon(AppIcons.person),
                  ),
                  validator: (value) => _validateName(value, l10n),
                ),
                const SizedBox(height: AppSpacing.xl),

                AuthFieldLabel(l10n.emailLabel),
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

                AuthFieldLabel(l10n.phoneLabel),
                // Phone numbers read left to right, even in Arabic.
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: l10n.phoneHint,
                      prefixIcon: const Icon(AppIcons.phone),
                    ),
                    validator: (value) => _validatePhone(value, l10n),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                AuthFieldLabel(l10n.createPasswordLabel),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  onFieldSubmitted: (_) => _createAccount(),
                  decoration: InputDecoration(
                    helperText: l10n.passwordRule(
                      Validators.minPasswordLength,
                    ),
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
                const SizedBox(height: AppSpacing.lg),

                _TermsCheckbox(
                  label: l10n.agreeTerms,
                  errorText: l10n.termsRequired,
                ),
                const SizedBox(height: AppSpacing.lg),

                if (registerState.hasError) ...[
                  AuthErrorBanner(
                    message: _messageFor(registerState.error, l10n),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                FilledButton(
                  onPressed: isLoading ? null : _createAccount,
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: AppSizes.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.progressStroke,
                            color: AppColors.onBrand,
                          ),
                        )
                      : Text(l10n.createAccount),
                ),
                const SizedBox(height: AppSpacing.lg),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l10n.alreadyHaveAccount, style: AppTextStyles.muted),
                    TextButton(
                      onPressed: () => context.pushReplacement(AppRoutes.login),
                      child: Text(l10n.logIn),
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

/// "I agree to the Terms…" checkbox. It's part of the form, so the form
/// won't submit until it's ticked, and it shows [errorText] if it isn't.
class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.label, required this.errorText});

  final String label;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: false,
      validator: (accepted) => accepted ?? false ? null : errorText,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: field.value ?? false,
                  onChanged: field.didChange,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: Text(label, style: AppTextStyles.muted),
                  ),
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: AppSpacing.md,
                ),
                child: Text(field.errorText ?? '', style: AppTextStyles.error),
              ),
          ],
        );
      },
    );
  }
}
