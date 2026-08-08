import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Presenta tarjetas de plantillas/recetas de automatización lista para usar (Slack, Alertas, Sheets).
/// ¿De dónde trae datos?: Datos estáticos de plantillas de integración Raft DB + n8n.
/// ¿Hacia dónde va / Cómo se conecta?: Se muestra debajo de la lista de flujos en N8nServicesPage.
class N8nTemplatesSection extends StatelessWidget {
  final void Function(String templateName) onUseTemplate; // Callback al presionar "Usar Plantilla"

  const N8nTemplatesSection({
    required this.onUseTemplate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo
    final isDark = theme.brightness == Brightness.dark; // Identifica modo noche

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del texto principal
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Color secundario

    // Lista estática de las 3 plantillas pre-diseñadas
    final templates = [
      {
        'title': 'Notificación de Backup en Slack/Discord',
        'desc': 'Envía una alerta automática a tu canal cuando se complete una copia de seguridad en Raft DB.',
        'icon': Icons.notifications_active_rounded,
        'color': AppColors.purple,
      },
      {
        'title': 'Alerta de Uso Crítico de Memoria/CPU',
        'desc': 'Recibe un correo o mensaje cuando el consumo de recursos de la base de datos supere el 85%.',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'Sincronización a Google Sheets',
        'desc': 'Exporta automáticamente nuevas filas de tu base de datos a una hoja de cálculo en tiempo real.',
        'icon': Icons.table_chart_rounded,
        'color': AppColors.success,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plantillas Recomendadas',
          style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Comienza rápidamente importando flujos pre-configurados para tu cluster de bases de datos.',
          style: TextStyle(color: subtitleColor, fontSize: 12),
        ),
        const SizedBox(height: 14),

        // Grilla horizontal o vertical de plantillas
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 750;

            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              children: templates.map((tpl) {
                final iconColor = tpl['color'] as Color;

                return Expanded(
                  flex: isWide ? 1 : 0,
                  child: Container(
                    margin: EdgeInsets.only(right: isWide ? 12 : 0, bottom: isWide ? 0 : 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icono distintivo
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(tpl['icon'] as IconData, color: iconColor, size: 20),
                        ),
                        const SizedBox(height: 10),

                        // Título de la plantilla
                        Text(
                          tpl['title'] as String,
                          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),

                        // Descripción de la plantilla
                        Text(
                          tpl['desc'] as String,
                          style: TextStyle(color: subtitleColor, fontSize: 11),
                        ),
                        const SizedBox(height: 12),

                        // Botón de acción
                        TextButton.icon(
                          onPressed: () => onUseTemplate(tpl['title'] as String), // Dispara callback
                          icon: const Icon(Icons.add_circle_outline_rounded, size: 14),
                          label: const Text('Usar Plantilla', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
