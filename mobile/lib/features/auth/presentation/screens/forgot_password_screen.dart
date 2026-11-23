import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';
import 'package:medlink/core/utils/validators.dart';
import 'package:medlink/features/auth/presentation/providers/forgot_password_controller.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_field_label.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_logo.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    await ref
        .read(forgotPasswordControllerProvider.notifier)
        .requestReset(_emailController.text.trim());
  }

  Future<void> _openVerifyScreen() async {
    final changed = await context.push<bool>(
      AppRoutes.verifyResetCode,
      extra: _emailController.text.trim(),
    );
    if (!mounted) return;
    if (changed ?? false) context.pop();
  }

  String _messageFor(Object? error, AppLocalizations l10n) {
    return switch (error) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final forgotState = ref.watch(forgotPasswordControllerProvider);
    final isLoading = forgotState.isLoading;

    ref.listen(forgotPasswordControllerProvider, (previous, next) {
      final finished = previous?.isLoading == true && next.hasValue;
      if (finished && !next.hasError) unawaited(_openVerifyScreen());
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
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AuthLogo(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.forgotTitle, style: AppTextStyles.screenTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.forgotSubtitle, style: AppTextStyles.screenSubtitle),
                const SizedBox(height: AppSpacing.xxxl),

                AuthFieldLabel(l10n.emailLabel),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.email],
                  autocorrect: false,
                  onFieldSubmitted: (_) => _continue(),
                  decoration: InputDecoration(
                    hintText: l10n.emailHint,
                    prefixIcon: const Icon(AppIcons.email),
                  ),
                  validator: (value) => _validateEmail(value, l10n),
                ),
                const SizedBox(height: AppSpacing.xxl),

                if (forgotState.hasError) ...[
                  AuthErrorBanner(
                    message: _messageFor(forgotState.error, l10n),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                FilledButton(
                  onPressed: isLoading ? null : _continue,
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: AppSizes.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.progressStroke,
                            color: AppColors.onBrand,
                          ),
                        )
                      : Text(l10n.continueButton),
                ),
                const SizedBox(height: AppSpacing.lg),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l10n.rememberPassword, style: AppTextStyles.muted),
                    TextButton(onPressed: context.pop, child: Text(l10n.logIn)),
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
