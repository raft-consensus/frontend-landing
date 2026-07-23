import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/guide_data.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common

/// ¿Qué hace?: Tarjeta gráfica expandible para ver un tutorial con badge de lenguaje y bloque de código copiable.
/// ¿De dónde trae?: Trae AppColors (core), GuideData (domain) y DashboardCard (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro del listado de DocumentationPage.
class GuideCard extends StatefulWidget {
  const GuideCard({
    required this.guide,      // Datos de la guía (título, descripción, codeSnippet)
    required this.onMessage,  // Callback para notificaciones snackbar al copiar código
    super.key,
  });

  final GuideData guide;
  final void Function(String message, {bool success}) onMessage;

  @override
  State<GuideCard> createState() => _GuideCardState();
}

class _GuideCardState extends State<GuideCard> {
  bool _expanded = false;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.guide.codeSnippet));
    widget.onMessage('Código de ${widget.guide.language} copiado al portapapeles.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    final guide = widget.guide;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera: Icono del lenguaje, Título, Tiempo y Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4E8FC)),
                ),
                child: Icon(guide.icon, color: AppColors.blue, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          guide.title,
                          style: const TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            guide.language,
                            style: const TextStyle(color: AppColors.blue, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, size: 12, color: AppColors.muted),
                        const SizedBox(width: 4),
                        Text('Lectura estimada: ${guide.time}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Descripción de la guía
          Text(
            guide.description,
            style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 14),

          // Bloque de código desplegable
          if (_expanded) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF03132F), // Fondo consola oscuro
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ejemplo ${guide.language}',
                        style: const TextStyle(color: Color(0xFF88A0C0), fontSize: 11, fontFamily: 'monospace'),
                      ),
                      InkWell(
                        onTap: _copyCode,
                        child: const Row(
                          children: [
                            Icon(Icons.copy_rounded, color: AppColors.cyan, size: 14),
                            SizedBox(width: 4),
                            Text('Copiar', style: TextStyle(color: AppColors.cyan, fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    guide.codeSnippet,
                    style: const TextStyle(color: Color(0xFFE0EDFB), fontSize: 12, fontFamily: 'monospace', height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Botón alternar expansión
          TextButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.code_rounded, size: 16),
            label: Text(_expanded ? 'Ocultar código' : 'Ver código de ejemplo'),
            style: TextButton.styleFrom(foregroundColor: AppColors.blue),
          ),
        ],
      ),
    );
  }
}
