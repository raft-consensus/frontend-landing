import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_icon.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_style.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_line.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/status_badge.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_card_actions.dart'; // Databases

/// ¿Qué hace?: Tarjeta modular de administración de BD con animación hover, logo PNG y sub-widgets descompuestos.
/// ¿De dónde trae datos?: Ingesta DatabaseInstance, callbacks de acción y se adapta al tema Día/Noche.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro de la grilla responsiva de 3 columnas de DatabasesPage.
class DatabaseManagementCard extends StatefulWidget {
  const DatabaseManagementCard({
    required this.instance,        // Instancia de base de datos a administrar
    required this.onToggleState,   // Callback para alternar estado encendido/apagado
    required this.onDelete,        // Callback para eliminar la instancia
    required this.onMessage,       // Callback para mensajes de retroalimentación
    super.key,
  });

  final DatabaseInstance instance;
  final VoidCallback onToggleState;
  final VoidCallback onDelete;
  final void Function(String, {bool success}) onMessage;

  @override
  State<DatabaseManagementCard> createState() => _DatabaseManagementCardState();
}

class _DatabaseManagementCardState extends State<DatabaseManagementCard> {
  // Estado local para resplandor hover al pasar el cursor sobre la tarjeta
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Estilo e icono del motor con color institucional dinámico Día/Noche
    final style = engineStyle(widget.instance.engine, theme.brightness);
    final engineColor = style.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: engineColor.withValues(alpha: isDark ? 0.25 : 0.15), // Resplandor sutil
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: DashboardCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Cabecera modular (Logo PNG, Nombre, Estado e ID)
              _DatabaseCardHeader(
                instance: widget.instance,
                engineStyleData: style,
                engineColor: engineColor,
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: theme.dividerColor),
              const SizedBox(height: 16),

              // 2. Grilla modular de información de conexión (Host, Puerto, BD, Usuario)
              _DatabaseCardInfoGrid(instance: widget.instance),
              const SizedBox(height: 18),

              // 3. Barra modular de progreso de almacenamiento
              _DatabaseStorageProgress(
                instance: widget.instance,
                engineColor: engineColor,
              ),
              const SizedBox(height: 20),

              // 4. Delegación modular a los botones de acción
              DatabaseCardActions(
                instance: widget.instance,
                onToggleState: widget.onToggleState,
                onDelete: widget.onDelete,
                onMessage: widget.onMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sub-widget privado: Cabecera con logo PNG transparente, Nombre, Versión, ID y StatusBadge
class _DatabaseCardHeader extends StatelessWidget {
  const _DatabaseCardHeader({
    required this.instance,
    required this.engineStyleData,
    required this.engineColor,
  });

  final DatabaseInstance instance;
  final EngineStyle engineStyleData;
  final Color engineColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        EngineIcon(
          engineName: instance.engine,
          icon: engineStyleData.icon,
          color: engineColor,
          small: false,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      instance.name,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(running: instance.isRunning),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${instance.engine} v${instance.version} • ID: ${instance.id}',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sub-widget privado: Detalles de conexión ordenados en 2 filas (Host, Puerto, BD, Usuario)
class _DatabaseCardInfoGrid extends StatelessWidget {
  const _DatabaseCardInfoGrid({required this.instance});

  final DatabaseInstance instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: InfoLine(icon: Icons.dns_rounded, label: 'Host', value: instance.host)),
            const SizedBox(width: 12),
            Expanded(child: InfoLine(icon: Icons.numbers_rounded, label: 'Puerto', value: '${instance.port}')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: InfoLine(icon: Icons.storage_rounded, label: 'BD', value: instance.database)),
            const SizedBox(width: 12),
            Expanded(child: InfoLine(icon: Icons.person_rounded, label: 'Usuario', value: instance.username)),
          ],
        ),
      ],
    );
  }
}

/// Sub-widget privado: Barra gráfica de progreso de almacenamiento
class _DatabaseStorageProgress extends StatelessWidget {
  const _DatabaseStorageProgress({
    required this.instance,
    required this.engineColor,
  });

  final DatabaseInstance instance;
  final Color engineColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Almacenamiento ocupado',
              style: TextStyle(color: subtitleColor, fontSize: 11),
            ),
            Text(
              '${instance.storageUsed.toInt()} MB / ${instance.storageLimit.toInt()} MB',
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (instance.storageUsed / instance.storageLimit).clamp(0.0, 1.0),
            backgroundColor: theme.dividerColor.withValues(alpha: isDark ? 0.30 : 0.50),
            valueColor: AlwaysStoppedAnimation<Color>(engineColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
