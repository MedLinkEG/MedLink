import 'package:flutter/material.dart';
import 'package:medlink/features/home/presentation/widgets/home_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [HomeHeader(hasUnreadNotifications: true)],
        ),
      ),
    );
  }
}
