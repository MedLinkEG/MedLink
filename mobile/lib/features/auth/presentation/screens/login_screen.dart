import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/constants/app_assets.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';
import 'package:medlink/core/utils/validators.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/presentation/providers/login_controller.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_field_label.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  Future<void> _logIn() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    await ref
        .read(loginControllerProvider.notifier)
        .logIn(
          LogInData(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  String _messageFor(Object? error, AppLocalizations l10n) {
    return switch (error) {
      UnauthorizedFailure() => l10n.errorInvalidCredentials,
      InvalidDataFailure() => l10n.errorInvalidData,
      NetworkFailure() => l10n.errorNetwork,
      ServerFailure() => l10n.errorServer,
      _ => l10n.errorUnknown,
    };
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
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;

    ref.listen(loginControllerProvider, (previous, next) {
      final finished = previous?.isLoading == true && next.hasValue;
      if (finished && !next.hasError) {
        context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      // Shows a back arrow automatically when opened from Welcome.
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
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _LogoTile(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.loginTitle, style: AppTextStyles.screenTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.loginSubtitle, style: AppTextStyles.screenSubtitle),
                const SizedBox(height: AppSpacing.xxxl),

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

                AuthFieldLabel(l10n.passwordLabel),
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
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(l10n.forgotPassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (loginState.hasError) ...[
                  AuthErrorBanner(message: _messageFor(loginState.error, l10n)),
                  const SizedBox(height: AppSpacing.lg),
                ],

                FilledButton(
                  onPressed: isLoading ? null : _logIn,
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: AppSizes.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.progressStroke,
                            color: AppColors.onBrand,
                          ),
                        )
                      : Text(l10n.logIn),
                ),
                const SizedBox(height: AppSpacing.lg),
                _OrDivider(label: l10n.orDivider),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(AppIcons.fingerprint),
                  label: Text(l10n.unlockWithFingerprint),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l10n.newToMedLink, style: AppTextStyles.muted),
                    TextButton(
                      onPressed: () =>
                          context.pushReplacement(AppRoutes.register),
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
    return Image.asset(
      AppAssets.logoMark,
      width: AppSizes.logoTile,
      height: AppSizes.logoTile,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
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
