// ==========================================
// Que hace: Tarjeta interactiva con enlace oficial de descarga y parametros recomendados de conexion desplegables.
// De donde trae datos: Recibe datos de la herramienta, URL oficial y snippet de conexion.
// Donde se conecta: Consumido dentro de ToolsGuideSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tarjeta de herramienta de gestion de bases de datos con boton de descarga oficial
class ToolDownloadCard extends StatefulWidget {
  const ToolDownloadCard({
    required this.title, // Nombre del gestor (ej. DBeaver, pgAdmin)
    required this.category, // Categoria (Multi-motor, PostgreSQL, NoSQL, etc.)
    required this.description, // Descripcion del gestor
    required this.icon, // Icono caracteristico
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
                  color: AppColors.blue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.blue.withValues(alpha: 0.20)),
                ),
                child: Icon(widget.icon, color: AppColors.blue, size: 22),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4E8FC)),
                ),
                child: Text(
                  widget.category,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. Titulo
          Text(
            widget.title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),

          // 3. Descripcion
          Text(
            widget.description,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // 4. Bloque desplegable de configuracion rapida
          if (_expanded) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF03132F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                widget.configSnippet,
                style: const TextStyle(
                  color: Color(0xFFE0EDFB),
                  fontSize: 11,
                  fontFamily: 'monospace',
                  height: 1.4,
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
                  size: 14,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  _expanded ? 'Ocultar parámetros' : 'Ver parámetros recomendados',
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 11,
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
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.border),
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
