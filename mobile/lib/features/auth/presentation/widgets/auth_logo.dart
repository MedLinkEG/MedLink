import 'package:flutter/material.dart';
import 'package:medlink/core/constants/app_assets.dart';
import 'package:medlink/core/theme/app_sizes.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

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
