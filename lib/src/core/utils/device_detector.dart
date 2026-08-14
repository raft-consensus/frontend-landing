// ==========================================
// Qué hace: Identifica si el cliente actual está ejecutando la aplicación o visitando la web desde un dispositivo móvil real (Android o iOS).
// Dónde se conecta: Utilizado por LandingPage para condicionar elementos exclusivos de teléfonos móviles.
// De dónde recibe datos: Consulta defaultTargetPlatform de foundation.dart.
// ==========================================

import 'package:flutter/foundation.dart';

/// Utilidad centralizada para determinar si el entorno actual es un teléfono móvil por plataforma.
abstract class DeviceDetector {
  /// ¿Qué hace?: Evalúa si el dispositivo es estrictamente un teléfono móvil según el sistema operativo (Android o iOS).
  /// ¿De dónde recibe datos?: defaultTargetPlatform del SDK de Flutter.
  /// ¿Hacia dónde va / Cómo se conecta?: Retorna true únicamente en dispositivos móviles reales (Android / iOS).
  static bool isMobile() {
    // Comprueba si el sistema operativo del cliente es Android o iOS
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// ¿Qué hace?: Evalúa específicamente si la plataforma es el sistema operativo Android.
  /// ¿De dónde recibe datos?: defaultTargetPlatform.
  /// ¿Hacia dónde va / Cómo se conecta?: Retorna true si la plataforma es Android.
  static bool isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }
}
