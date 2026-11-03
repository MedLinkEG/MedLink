import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF02346B);
  static const teal = Color(0xFF067F72);

  static const background = Color(0xFFF4F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const tileStart = Color(0xFFE1ECF8);
  static const tileEnd = Color(0xFFDCF3EE);
  static const navBorder = Color(0xFFDCE6EA);

  static const textPrimary = Color(0xFF10283F);
  static const textSecondary = Color(0xFF4A6173);
  static const textThried = Color(0xFF1F5F78);

  static const discountBg = Color(0xFFFFE3B8);
  static const discountText = Color(0xFF6B4200);

  static const notificationDot = Color(0xFFF2A33A);
  static const notificationDotBorder = Color(0xFF0B5E78);
  static const glassFill = Color(0x2EFFFFFF);
  static const glassBorder = Color(0x59FFFFFF);

  static const Color dotActive = navy;
  static const dotInactive = Color(0xFFB8C7D0);

  static const cardShadow = Color(0x1410283F);
  static const searchShadow = Color(0x4702346B);

  static const outlinedButtonColor = Color(0xFF2A7B9B);

  static const brandGradient = LinearGradient(
    begin: Alignment(-1, -0.6),
    end: Alignment(1, 0.6),
    colors: [navy, teal],
  );
}
