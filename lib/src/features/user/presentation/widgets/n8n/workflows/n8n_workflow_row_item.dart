import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/n8n_workflow.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/workflows/n8n_workflow_actions.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/workflows/n8n_workflow_status_badge.dart';

/// ¿Qué hace?: Renderiza la fila individual de un flujo de trabajo dentro de la tabla/lista.
/// ¿De dónde trae datos?: Ingesta la entidad N8nWorkflow y gestiona sus callbacks de acción.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza repetitivamente dentro de N8nWorkflowsList.
class N8nWorkflowRowItem extends StatelessWidget {
  final N8nWorkflow workflow;             // Entidad con los datos del flujo
  final VoidCallback onToggleStatus;      // Evento para cambiar el estado activo/pausado
  final VoidCallback onCopyWebhook;       // Evento para copiar el webhook

  const N8nWorkflowRowItem({
    required this.workflow,
    required this.onToggleStatus,
    required this.onCopyWebhook,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo
    final isDark = theme.brightness == Brightness.dark; // Identifica modo noche

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del título
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Color del subtítulo

    // Formatea la fecha de manera legible (ej: "10:45")
    final timeStr = '${workflow.lastExecutedAt.hour.toString().padLeft(2, '0')}:${workflow.lastExecutedAt.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icono circular con color dinámico según el estado
          CircleAvatar(
            radius: 18,
            backgroundColor: workflow.isActive
                ? Colors.green.withValues(alpha: 0.12)
                : Colors.orange.withValues(alpha: 0.12),
            child: Icon(
              workflow.isActive ? Icons.bolt_rounded : Icons.pause_rounded,
              color: workflow.isActive ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Información del flujo (Nombre, Disparador y Fecha)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workflow.name, // Nombre del flujo
                  style: TextStyle(color: titleColor, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'Trigger: ${workflow.trigger} • Última ej: $timeStr • Total: ${workflow.executionCount} ej',
                  style: TextStyle(color: subtitleColor, fontSize: 11),
                ),
              ],
            ),
          ),

          // Badge de estado (Activo / Pausado)
          N8nWorkflowStatusBadge(isActive: workflow.isActive),
          const SizedBox(width: 12),

          // Botones de acción rápida
          N8nWorkflowActions(
            isActive: workflow.isActive,
            onToggleStatus: onToggleStatus,
            onCopyWebhook: onCopyWebhook,
          ),
        ],
      ),
    );
  }
}
