import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/routers/app_router.dart';
import 'package:frontend_landing/src/core/theme/app_theme.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend_landing/src/core/theme/theme_provider.dart';

/// Punto de entrada principal de la aplicación.
void main() {
  // Configura Flutter Web para usar URLs limpias de HTML5 (PathUrlStrategy) eliminando el '#'
  usePathUrlStrategy();

  runApp(
    // ProviderScope inicializa el árbol de estados globales de Riverpod
    const ProviderScope(child: MyApp()),
  );
}

/// Widget raíz de la aplicación que configura el tema y escucha las rutas de Riverpod.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el router reactivo con protección de rutas
    final router = ref.watch(routerProvider);
    // Tema, modo oscuro y claro
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Raft Cloud',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // Agregado
      themeMode: themeMode, // Agregado
      routerConfig: router, // Router dinámico reactivo
    );
  }
}
