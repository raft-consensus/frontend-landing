// ==========================================
// Qué hace: Banner interactivo superior tipo Smart App Banner que invita a descargar la app móvil de Raft Cloud en Play Store.
// Dónde se conecta: Renderizado condicionalmente en la cabecera de LandingPage si se detecta un teléfono móvil.
// De dónde recibe datos: Utiliza url_launcher para redireccionar a la URL hipotética de Google Play Store.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Componente visual de banner de descarga para dispositivos móviles.
class MobilePlayStoreBanner extends StatefulWidget {
  const MobilePlayStoreBanner({
    super.key,
    this.playStoreUrl = 'https://play.google.com/store/apps/details?id=dev.andrescortes.raftdb', // URL hipotética de la app
  });

  // Enlace web o deep link hacia la ficha de la aplicación en Google Play Store
  final String playStoreUrl;

  @override
  State<MobilePlayStoreBanner> createState() => _MobilePlayStoreBannerState();
}

class _MobilePlayStoreBannerState extends State<MobilePlayStoreBanner> {
  // Bandera de estado local para ocultar el banner si el usuario presiona el botón de cerrar
  bool _isVisible = true;

  /// ¿Qué hace?: Lanza el enlace externo hacia Google Play Store en el navegador o en la app de la tienda.
  /// ¿De dónde recibe datos?: Obtiene la URL de widget.playStoreUrl.
  /// ¿Hacia dónde va / Cómo se conecta?: Invoca launchUrl con modo externalApplication.
  Future<void> _openPlayStore() async {
    final Uri uri = Uri.parse(widget.playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Redirige a la aplicación externa de Play Store
      );
    }
  }

  /// ¿Qué hace?: Desactiva la visibilidad del banner en el estado local.
  /// ¿De dónde recibe datos?: Evento de clic en el botón de cerrar.
  /// ¿Hacia dónde va / Cómo se conecta?: Actualiza _isVisible a false provocando un re-render sin el banner.
  void _dismissBanner() {
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si el usuario cerró el banner, no ocupa espacio visual
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark; // Comprueba tema activo

    return Container(
      width: double.infinity, // Ocupa todo el ancho horizontal
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), // Margen interno
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightSurface : const Color(0xFF0A2946), // Fondo corporativo profundo
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.nightBorder : AppColors.dayBorder.withValues(alpha: 0.3), // Borde divisor inferior
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false, // Aplica área segura únicamente para la parte superior
        child: Row(
          children: [
            // Contenedor con icono de Android / Play Store
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.nightCard : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.android_rounded, // Icono de Android
                color: Color(0xFF3DDC84), // Verde Android oficial
                size: 22,
              ),
            ),
            const SizedBox(width: 10), // Separación horizontal

            // Textos informativos de la aplicación
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Raft Cloud para Android', // Título principal del banner
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Disponible gratis en Google Play Store', // Subtítulo descriptivo
                    style: TextStyle(
                      color: isDark ? AppColors.nightTextSecondary : const Color(0xFFD4E6F8),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Separación horizontal

            // Botón de acción para descargar / instalar
            ElevatedButton(
              onPressed: _openPlayStore,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.nightPrimary : AppColors.cyan, // Color de botón
                foregroundColor: isDark ? AppColors.nightBackground : AppColors.dayPrimary, // Color de texto
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: const Size(60, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Instalar', // Etiqueta del botón
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 4), // Separación

            // Botón para cerrar y descartar el banner
            IconButton(
              onPressed: _dismissBanner,
              icon: const Icon(Icons.close_rounded, size: 18),
              color: Colors.white70,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: 'Cerrar',
            ),
          ],
        ),
      ),
    );
  }
}
