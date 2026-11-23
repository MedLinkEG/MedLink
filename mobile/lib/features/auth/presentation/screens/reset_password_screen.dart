import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/constants/app_icons.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';
import 'package:medlink/core/utils/validators.dart';
import 'package:medlink/features/auth/domain/entities/reset_password_data.dart';
import 'package:medlink/features/auth/presentation/providers/reset_password_controller.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_field_label.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_logo.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

/// Forgot password, step 3: the new password, typed twice. On success it
/// shows "Password changed" and closes with `true`, so Check your email and
/// Forgot password close too and the user is back on Log in.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({required this.resetToken, super.key});

  /// The token the backend gave back for the right code.
  final String resetToken;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    await ref
        .read(resetPasswordControllerProvider.notifier)
        .resetPassword(
          ResetPasswordData(
            resetToken: widget.resetToken,
            newPassword: _passwordController.text,
          ),
        );
  }

  String _messageFor(Object? error, AppLocalizations l10n) {
    return switch (error) {
      // A wrong or old reset token.
      InvalidDataFailure() || UnauthorizedFailure() => l10n.errorResetExpired,
      NetworkFailure() => l10n.errorNetwork,
      ServerFailure() => l10n.errorServer,
      _ => l10n.errorUnknown,
    };
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

  String? _validateConfirm(String? value, AppLocalizations l10n) {
    final confirm = value ?? '';
    if (confirm.isEmpty) return l10n.confirmPasswordRequired;
    if (confirm != _passwordController.text) return l10n.passwordsDontMatch;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resetState = ref.watch(resetPasswordControllerProvider);
    final isLoading = resetState.isLoading;

    ref.listen(resetPasswordControllerProvider, (previous, next) {
      final finished = previous?.isLoading == true && next.hasValue;
      if (finished && !next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.passwordChanged)));
        context.pop(true);
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
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AuthLogo(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.resetTitle, style: AppTextStyles.screenTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.resetSubtitle, style: AppTextStyles.screenSubtitle),
                const SizedBox(height: AppSpacing.xxxl),

                AuthFieldLabel(l10n.newPasswordLabel),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(
                    helperText: l10n.passwordRule(
                      Validators.minPasswordLength,
                    ),
                    prefixIcon: const Icon(AppIcons.lock),
                    suffixIcon: _EyeButton(
                      hidden: _hidePassword,
                      showLabel: l10n.showPassword,
                      hideLabel: l10n.hidePassword,
                      onPressed: () =>
                          setState(() => _hidePassword = !_hidePassword),
                    ),
                  ),
                  validator: (value) => _validatePassword(value, l10n),
                ),
                const SizedBox(height: AppSpacing.xl),

                AuthFieldLabel(l10n.confirmPasswordLabel),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _hideConfirm,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  onFieldSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(AppIcons.lock),
                    suffixIcon: _EyeButton(
                      hidden: _hideConfirm,
                      showLabel: l10n.showPassword,
                      hideLabel: l10n.hidePassword,
                      onPressed: () =>
                          setState(() => _hideConfirm = !_hideConfirm),
                    ),
                  ),
                  validator: (value) => _validateConfirm(value, l10n),
                ),
                const SizedBox(height: AppSpacing.xxl),

                if (resetState.hasError) ...[
                  AuthErrorBanner(message: _messageFor(resetState.error, l10n)),
                  const SizedBox(height: AppSpacing.lg),
                ],

                FilledButton(
                  onPressed: isLoading ? null : _save,
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: AppSizes.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.progressStroke,
                            color: AppColors.onBrand,
                          ),
                        )
                      : Text(l10n.savePassword),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EyeButton extends StatelessWidget {
  const _EyeButton({
    required this.hidden,
    required this.showLabel,
    required this.hideLabel,
    required this.onPressed,
  });

  final bool hidden;
  final String showLabel;
  final String hideLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: hidden ? showLabel : hideLabel,
      icon: Icon(hidden ? AppIcons.showPassword : AppIcons.hidePassword),
    );
  }
}
