// ==========================================
// Que hace: Tarjeta interactiva con enlace oficial de descarga y parametros recomendados de conexion desplegables.
// De donde trae datos: Recibe datos del software, URL oficial y snippet de configuracion.
// Donde se conecta: Consumido dentro de ToolsGrid.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tarjeta de herramienta de desarrollo con soporte de tema dinamico
class ToolDownloadCard extends StatefulWidget {
  const ToolDownloadCard({
    required this.title, // Nombre del software (ej. DBeaver, Postman)
    required this.category, // Categoria (Multi-motor, APIs, Terminal, etc.)
    required this.description, // Descripcion del software
    required this.icon, // Icono representativo
    required this.officialUrl, // Enlace oficial de descarga
    required this.configSnippet, // Parametros de configuracion recomendados
    required this.onMessage, // Callback para notificaciones
    super.key,
  });

  final String title; // Nombre del software
  final String category; // Categoria
  final String description; // Descripcion
  final IconData icon; // Icono
  final String officialUrl; // URL oficial
  final String configSnippet; // Instrucciones de conexion
  final void Function(String message, {bool success}) onMessage; // Callback

  @override
  State<ToolDownloadCard> createState() => _ToolDownloadCardState();
}

class _ToolDownloadCardState extends State<ToolDownloadCard> {
  bool _expanded = false; // Estado del acordeon de configuracion

  /// Abre la URL oficial de descarga en el navegador externo
  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.officialUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        widget.onMessage('No se pudo abrir el enlace oficial.', success: false);
      }
    } catch (_) {
      widget.onMessage('Error al intentar abrir el navegador.', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Encabezado: Icono + Categoria
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: isDark ? 0.20 : 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
                ),
                child: Icon(widget.icon, color: primaryColor, size: 22),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF132B45) : const Color(0xFFEBF5FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF20456C) : const Color(0xFFC7E2FE),
                  ),
                ),
                child: Text(
                  widget.category,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. Titulo con contraste adaptativo
          Text(
            widget.title,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),

          // 3. Descripcion
          Text(
            widget.description,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),

          // 4. Bloque desplegable de configuracion rapida
          if (_expanded) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF071220) : const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFF334155),
                ),
              ),
              child: SelectableText(
                widget.configSnippet,
                style: const TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontSize: 11.5,
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // 5. Boton alternar guia de configuracion
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Icon(
                  _expanded ? Icons.keyboard_arrow_up_rounded : Icons.tune_rounded,
                  size: 15,
                  color: primaryColor,
                ),
                const SizedBox(width: 5),
                Text(
                  _expanded ? 'Ocultar parámetros' : 'Ver parámetros recomendados',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 6. Boton oficial de descarga
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _launchUrl,
              icon: const Icon(Icons.download_rounded, size: 16),
              label: const Text('Descargar / Sitio Oficial'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                side: BorderSide(color: theme.dividerColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
