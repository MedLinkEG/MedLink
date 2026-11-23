import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/core/theme/app_sizes.dart';
import 'package:medlink/core/theme/app_text_styles.dart';

class CodeBoxesField extends StatefulWidget {
  const CodeBoxesField({
    required this.controller,
    required this.length,
    this.validator,
    this.onCompleted,
    super.key,
  });

  final TextEditingController controller;
  final int length;
  final FormFieldValidator<String>? validator;

  /// Called when the last digit is typed.
  final VoidCallback? onCompleted;

  @override
  State<CodeBoxesField> createState() => _CodeBoxesFieldState();
}

class _CodeBoxesFieldState extends State<CodeBoxesField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _onChanged(String value) {
    if (value.length == widget.length) widget.onCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Digits read left to right, even in Arabic.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.oneTimeCode],
            maxLength: widget.length,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            showCursor: false,
            enableInteractiveSelection: false,
            style: const TextStyle(color: Colors.transparent),
            onChanged: _onChanged,
            validator: widget.validator,
            decoration: const InputDecoration(
              counterText: '',
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              constraints: BoxConstraints(minHeight: AppSizes.codeBox),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: AppSizes.codeBox,
            child: GestureDetector(
              onTap: _focusNode.requestFocus,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: widget.controller,
                builder: (context, value, _) {
                  final digits = value.text;
                  final next = math.min(digits.length, widget.length - 1);
                  return Row(
                    spacing: AppSpacing.sm,
                    children: [
                      for (var i = 0; i < widget.length; i++)
                        Expanded(
                          child: _CodeBox(
                            digit: i < digits.length ? digits[i] : '',
                            isNext: _focusNode.hasFocus && i == next,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox({required this.digit, required this.isNext});

  final String digit;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isNext ? AppColors.navy : AppColors.navBorder,
          width: isNext ? AppSizes.borderThick : AppSizes.borderThin,
        ),
      ),
      child: Text(digit, style: AppTextStyles.code),
    );
  }
}
