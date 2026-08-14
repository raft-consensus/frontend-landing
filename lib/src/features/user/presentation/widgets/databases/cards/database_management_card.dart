// ==========================================
// Qué hace: Tarjeta contenedora modular de administración de BD con animación hover y composición limpia.
// Dónde se conecta: Renderizado dentro de DatabaseGrid en DatabasesPage.
// De dónde recibe datos: Recibe DatabaseInstance, callbacks de acción y mensajería.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_style.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/cards/database_card_actions.dart'; // Databases
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/cards/database_card_header.dart'; // Databases
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/cards/database_card_info_grid.dart'; // Databases
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/cards/database_storage_progress.dart'; // Databases

/// Tarjeta principal de administración de base de datos desacoplada en subcomponentes limpios
class DatabaseManagementCard extends StatefulWidget {
  const DatabaseManagementCard({
    required this.instance,      // Instancia de base de datos a administrar
    required this.onToggleState, // Callback para alternar estado encendido/apagado
    required this.onDelete,      // Callback para eliminar la instancia
    required this.onMessage,     // Callback para mensajes de retroalimentación
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

    // Estilo e icono del motor con color dinámico Día/Noche
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
                    color: engineColor.withValues(
                      alpha: isDark ? 0.25 : 0.15,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
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
              DatabaseCardHeader(
                instance: widget.instance,
                engineStyleData: style,
                engineColor: engineColor,
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: theme.dividerColor),
              const SizedBox(height: 16),

              // 2. Grilla modular de detalles de conexión (Host, Puerto, BD, Usuario)
              DatabaseCardInfoGrid(instance: widget.instance),
              const SizedBox(height: 18),

              // 3. Barra modular de progreso de almacenamiento
              DatabaseStorageProgress(
                instance: widget.instance,
                engineColor: engineColor,
              ),
              const SizedBox(height: 20),

              // 4. Botones gráficos de acción (Credenciales, Detener/Iniciar, Eliminar)
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
