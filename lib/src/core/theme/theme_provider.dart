import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ¿Qué hace?: Controla el modo del tema visual (Claro / Oscuro) de la aplicación mediante Riverpod.
/// ¿De dónde recibe datos?: Invocado al presionar el botón de cambio de tema en el Topbar.
/// ¿Dónde se conecta?: Consumido por MaterialApp.router en main.dart y DashboardTopbar.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  /// Alterna entre el modo claro y el modo oscuro
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

/// Proveedor global para consultar y alternar el tema visual
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
