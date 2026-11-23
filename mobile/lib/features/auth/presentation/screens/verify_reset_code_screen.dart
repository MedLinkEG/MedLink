import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/router/app_routes.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';
import 'package:medlink/core/utils/validators.dart';
import 'package:medlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:medlink/features/auth/presentation/providers/verify_code_controller.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_field_label.dart';
import 'package:medlink/features/auth/presentation/widgets/auth_logo.dart';
import 'package:medlink/features/auth/presentation/widgets/code_boxes_field.dart';
import 'package:medlink/l10n/generated/app_localizations.dart';

class VerifyResetCodeScreen extends ConsumerStatefulWidget {
  const VerifyResetCodeScreen({required this.email, super.key});

  /// The email the code was sent to.
  final String email;

  @override
  ConsumerState<VerifyResetCodeScreen> createState() =>
      _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState
    extends ConsumerState<VerifyResetCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _resending = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    // The last digit also sends the code, so don't send it twice.
    if (ref.read(verifyCodeControllerProvider).isLoading) return;
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    await ref
        .read(verifyCodeControllerProvider.notifier)
        .verify(email: widget.email, code: _codeController.text.trim());
  }

  Future<void> _openResetScreen(String resetToken) async {
    final changed = await context.push<bool>(
      AppRoutes.resetPassword,
      extra: resetToken,
    );
    if (!mounted) return;
    if (changed ?? false) context.pop(true);
  }

  Future<void> _resend(AppLocalizations l10n) async {
    setState(() => _resending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(requestPasswordResetProvider)(widget.email);
      messenger.showSnackBar(SnackBar(content: Text(l10n.codeResent)));
    } on Failure catch (failure) {
      messenger.showSnackBar(
        SnackBar(content: Text(_messageFor(failure, l10n))),
      );
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  String _messageFor(Object? error, AppLocalizations l10n) {
    return switch (error) {
      InvalidDataFailure() || UnauthorizedFailure() => l10n.errorWrongCode,
      NetworkFailure() => l10n.errorNetwork,
      ServerFailure() => l10n.errorServer,
      _ => l10n.errorUnknown,
    };
  }

  String? _validateCode(String? value, AppLocalizations l10n) {
    final code = value?.trim() ?? '';
    if (code.isEmpty) return l10n.codeRequired;
    if (code.length != Validators.resetCodeLength) return l10n.codeIncomplete;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final verifyState = ref.watch(verifyCodeControllerProvider);
    final isLoading = verifyState.isLoading;

    ref.listen(verifyCodeControllerProvider, (previous, next) {
      final token = next.value;
      final finished = previous?.isLoading == true && !next.hasError;
      if (finished && token != null) unawaited(_openResetScreen(token));
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
                Text(l10n.verifyTitle, style: AppTextStyles.screenTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.verifySubtitle(widget.email),
                  style: AppTextStyles.screenSubtitle,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                AuthFieldLabel(l10n.codeLabel),
                CodeBoxesField(
                  controller: _codeController,
                  length: Validators.resetCodeLength,
                  validator: (value) => _validateCode(value, l10n),
                  onCompleted: _verify,
                ),
                const SizedBox(height: AppSpacing.xxl),

                if (verifyState.hasError) ...[
                  AuthErrorBanner(
                    message: _messageFor(verifyState.error, l10n),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                FilledButton(
                  onPressed: isLoading ? null : _verify,
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: AppSizes.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.progressStroke,
                            color: AppColors.onBrand,
                          ),
                        )
                      : Text(l10n.verifyButton),
                ),
                const SizedBox(height: AppSpacing.lg),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l10n.didntGetCode, style: AppTextStyles.muted),
                    TextButton(
                      onPressed: _resending ? null : () => _resend(l10n),
                      child: Text(l10n.resendCode),
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
