import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Banner de acceso directo a n8n Studio y copia rápida de credenciales (API Key y Webhook Base URL).
/// ¿De dónde trae datos?: Ingesta la URL de Studio, la API Key y la URL Base de Webhooks del usuario.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza debajo de las tarjetas KPI en N8nServicesPage.
class N8nAccessBanner extends StatelessWidget {
  final String studioUrl;       // URL web para ingresar a n8n Studio
  final String apiKey;          // API Key personal del usuario
  final String webhookBaseUrl;  // URL base de Webhooks para disparadores
  final void Function(String message, {bool success}) onMessage; // Callback para mostrar mensajes SnackBar

  const N8nAccessBanner({
    required this.studioUrl,
    required this.apiKey,
    required this.webhookBaseUrl,
    required this.onMessage,
    super.key,
  });

  /// Método privado para abrir la URL de n8n Studio en una pestaña externa del navegador
  Future<void> _launchStudio() async {
    final uri = Uri.parse(studioUrl); // Convierte la cadena en objeto Uri
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Abre la URL en una ventana externa
    } else {
      onMessage('No se pudo abrir el enlace a n8n Studio', success: false); // Notifica error si no se pudo abrir
    }
  }

  /// Método privado para copiar texto al portapapeles y notificar al usuario
  void _copyToClipboard(String textToCopy, String label) {
    Clipboard.setData(ClipboardData(text: textToCopy)); // Copia el texto al portapapeles de la computadora
    onMessage('$label copiado al portapapeles', success: true); // Muestra mensaje de éxito
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo
    final isDark = theme.brightness == Brightness.dark; // Identifica modo noche

    final cardBg = isDark ? AppColors.nightCard : Colors.white; // Color de fondo del banner
    final primaryTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del título
    final secondaryTextColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Color del subtítulo

    return Container(
      padding: const EdgeInsets.all(20), // Margen interno
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14), // Esquinas redondeadas
        border: Border.all(color: theme.dividerColor), // Borde perimetral
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icono distintivo de n8n o conectores
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.open_in_browser_rounded, color: AppColors.navy, size: 24),
              ),
              const SizedBox(width: 14),

              // Título y descripción breve del servicio n8n Studio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entorno de Trabajo n8n Studio',
                      style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Crea, edita y automatiza tus flujos visuales utilizando la plataforma de n8n.',
                      style: TextStyle(color: secondaryTextColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Botones de acción principal (Abrir Studio, Copiar API Key, Copiar Webhook URL)
          Wrap(
            spacing: 12, // Espaciado entre botones en horizontal
            runSpacing: 8, // Espaciado si el contenido baja de línea en pantallas pequeñas
            children: [
              // Botón primario: Abrir n8n Studio
              ElevatedButton.icon(
                onPressed: _launchStudio, // Dispara la apertura del navegador
                icon: const Icon(Icons.launch_rounded, size: 16, color: Colors.white),
                label: const Text('Abrir n8n Studio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy, // Fondo azul marino corporativo
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              // Botón secundario: Copiar API Key
              OutlinedButton.icon(
                onPressed: () => _copyToClipboard(apiKey, 'API Key de n8n'), // Copia la clave de API
                icon: const Icon(Icons.key_rounded, size: 16),
                label: const Text('Copiar API Key'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              // Botón secundario: Copiar URL Base de Webhooks
              OutlinedButton.icon(
                onPressed: () => _copyToClipboard(webhookBaseUrl, 'URL Base de Webhooks'), // Copia la URL de Webhook
                icon: const Icon(Icons.link_rounded, size: 16),
                label: const Text('Copiar URL Webhooks'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
