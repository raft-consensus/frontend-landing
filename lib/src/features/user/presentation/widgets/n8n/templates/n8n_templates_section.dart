import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/templates/n8n_template_card_item.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/templates/n8n_template_modal.dart';

/// ¿Qué hace?: Sección contenedora que agrupa la lista de plantillas pre-configuradas y gestiona la apertura de su modal.
/// ¿De dónde trae datos?: Lista estática de recetas integradas con Raft DB.
/// ¿Hacia dónde va / Cómo se conecta?: Consumido en N8nServicesPage.
class N8nTemplatesSection extends StatelessWidget {
  final void Function(String message, {bool success}) onMessage; // Callback para notificaciones

  const N8nTemplatesSection({
    required this.onMessage,
    super.key,
  });

  void _openTemplateModal(BuildContext context, String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => N8nTemplateModal(
        templateTitle: title,
        templateDesc: desc,
        onMessage: onMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    final templates = [
      {
        'title': 'Notificación de Backup en Slack/Discord',
        'desc': 'Envía una alerta automática a tu canal cuando se complete una copia de seguridad en Raft Cloud.',
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
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 750;

            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              children: templates.map((tpl) {
                final tTitle = tpl['title'] as String;
                final tDesc = tpl['desc'] as String;

                return Expanded(
                  flex: isWide ? 1 : 0,
                  child: Container(
                    margin: EdgeInsets.only(right: isWide ? 12 : 0, bottom: isWide ? 0 : 12),
                    child: N8nTemplateCardItem(
                      title: tTitle,
                      desc: tDesc,
                      icon: tpl['icon'] as IconData,
                      color: tpl['color'] as Color,
                      onUse: (_) => _openTemplateModal(context, tTitle, tDesc),
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
