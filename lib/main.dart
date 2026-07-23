import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_theme.dart';
import 'package:frontend_landing/src/features/landing/presentation/screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raft DB',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LandingScreen(),
    );
  }
}

