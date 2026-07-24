import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/routers/app_router.dart';
import 'package:frontend_landing/src/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Raft DB',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router, // Conecta nuestro router de URLs
    );
  }
}


