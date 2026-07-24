import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/routers/app_router.dart';
import 'package:frontend_landing/src/core/theme/app_theme.dart';

/// Punto de entrada principal de la aplicación.
void main() {
  runApp(
    // ProviderScope inicializa el árbol de estados globales de Riverpod
    const ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Raft DB',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router, // Router central de navegación
    );
  }
}
