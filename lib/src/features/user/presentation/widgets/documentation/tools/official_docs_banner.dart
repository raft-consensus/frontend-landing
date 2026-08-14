// ==========================================
// Que hace: Banner especial destacado con enlace externo a la documentacion tecnica de Raft en Docusaurus.
// De donde trae datos: Enlace oficial https://docs.raft.andrescortes.dev.
// Donde se conecta: Renderizado en la parte superior de ToolsGuideSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Banner destacado que redirige al sitio oficial de Docusaurus de Raft
class OfficialDocsBanner extends StatelessWidget {
  const OfficialDocsBanner({
    required this.onMessage, // Callback para notificaciones
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  static const String docsUrl = 'https://docs.raft.andrescortes.dev';

  Future<void> _launchDocs() async {
    final uri = Uri.parse(docsUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        onMessage('No se pudo abrir el sitio de documentación.', success: false);
      }
    } catch (_) {
      onMessage('Error al abrir la documentación oficial.', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2238) : const Color(0xFFEBF5FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.menu_book_rounded, color: primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documentación Técnica Oficial (Docusaurus)',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Accede a la arquitectura interna, guías de consenso distribuido Raft y referencia detallada de API en docs.raft.andrescortes.dev.',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: _launchDocs,
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: const Text('Abrir Documentación'),
            style: FilledButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: isDark ? AppColors.nightBackground : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
