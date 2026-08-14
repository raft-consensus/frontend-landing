// ==========================================
// Archivo: lib/src/core/utils/device_detector_stub.dart
// Qué hace: Implementación de respaldo (stub) para plataformas no web.
// Dónde se conecta: Importado condicionalmente por device_detector.dart.
// De dónde recibe datos: Retorna false por defecto al compilarse en entornos VM/Desktop nativo.
// ==========================================

/// ¿Qué hace?: Retorna false en entornos no web para la comprobación de navegador móvil.
/// ¿De dónde recibe datos?: N/A.
/// ¿Hacia dónde va / Cómo se conecta?: Respaldo para plataformas nativas.
bool isMobileBrowser() => false;
