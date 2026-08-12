import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/banner/n8n_banner_actions.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/banner/n8n_banner_header.dart';

/// ¿Qué hace?: Widget contenedor principal que coordina el encabezado y las acciones del banner de n8n.
/// ¿De dónde trae datos?: Ingesta estado de activación, URLs de la cuenta y callbacks de notificaciones.
/// ¿Hacia dónde va / Cómo se conecta?: Consumido directamente en N8nServicesPage.
class N8nAccessBanner extends StatefulWidget {
  final bool isActivated;                           // Booleano: indica si la cuenta está lista
  final String studioUrl;                           // Enlace credential a n8n Studio retornado de la BD
  final String apiKey;                              // API Key o Token personal
  final String webhookBaseUrl;                      // URL base de Webhooks
  final Future<void> Function() onProvision;        // Callback asincrónico para aprovisionar cuenta en backend
  final void Function(String message, {bool success}) onMessage; // Callback para notificaciones SnackBar

  const N8nAccessBanner({
    required this.isActivated,
    required this.studioUrl,
    required this.apiKey,
    required this.webhookBaseUrl,
    required this.onProvision,
    required this.onMessage,
    super.key,
  });

  @override
  State<N8nAccessBanner> createState() => _N8nAccessBannerState();
}

class _N8nAccessBannerState extends State<N8nAccessBanner> {
  bool _isProvisioning = false; // Estado de carga interno

  /// Abre la URL del espacio de trabajo en una nueva pestaña del navegador
  Future<void> _launchStudio() async {
    final url = widget.studioUrl.trim();
    if (url.isEmpty || !url.startsWith('http')) {
      widget.onMessage(
        'El enlace de acceso a tu espacio de n8n no está disponible aún. Por favor presiona "Activar cuenta n8n".',
        success: false,
      );
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      widget.onMessage('No se pudo abrir el enlace a n8n Studio', success: false);
    }
  }

  /// Copia un texto o URL al portapapeles con notificación
  void _copyToClipboard(String textToCopy, String label) {
    final text = textToCopy.trim();
    if (text.isEmpty || !text.startsWith('http')) {
      widget.onMessage(
        'El $label no está disponible actualmente. Por favor activa la cuenta.',
        success: false,
      );
      return;
    }
    Clipboard.setData(ClipboardData(text: text));
    widget.onMessage('$label copiado al portapapeles', success: true);
  }

  /// Maneja el evento de clic en "Activar cuenta n8n" esperando la petición HTTP del backend
  Future<void> _handleProvision() async {
    setState(() => _isProvisioning = true);
    try {
      await widget.onProvision();
    } finally {
      if (mounted) {
        setState(() => _isProvisioning = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.nightCard : Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-widget atómico del Encabezado
          N8nBannerHeader(isActivated: widget.isActivated),
          const SizedBox(height: 16),

          // Sub-widget atómico de Acciones
          N8nBannerActions(
            isActivated: widget.isActivated,
            isProvisioning: _isProvisioning,
            onProvision: _handleProvision,
            onLaunch: _launchStudio,
            onCopyLink: () => _copyToClipboard(widget.studioUrl, 'Enlace de Registro'),
          ),
        ],
      ),
    );
  }
}
