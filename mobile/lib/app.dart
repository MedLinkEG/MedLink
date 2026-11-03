import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_theme.dart';
import 'package:medlink/features/home/presentation/home_page.dart';

class MedLinkApp extends StatelessWidget {
  const MedLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}
