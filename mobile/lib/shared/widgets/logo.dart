import 'package:flutter/material.dart';
import 'package:medlink/core/constants/app_assets.dart';

class MedLinkLogo extends StatelessWidget {
  const MedLinkLogo({super.key, this.height = 36});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.logoWhite, height: height);
  }
}
