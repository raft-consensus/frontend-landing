import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_icon.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_style.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_line.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/status_badge.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/credentials_dialog.dart'; // Dialogs

/// ¿Qué hace?: Tarjeta interactiva detallada para administrar una BD (encender/apagar, ver credenciales o eliminar).
/// ¿De dónde trae?: Trae AppColors (core), DatabaseInstance (domain), widgets de common y CredentialsDialog (dialogs).
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro del listado principal de DatabasesPage.
class DatabaseManagementCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final style = engineStyle(instance.engine);
    final isDesktop = MediaQuery.of(context).size.width >= 700;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la tarjeta: Icono del motor, Nombre, Estado e Identificador
          Row(
            children: [
              EngineIcon(icon: style.icon, color: style.color),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          instance.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Badge de estado Activa/Detenida
                        StatusBadge(running: instance.isRunning),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${instance.engine} v${instance.version} • ID: ${instance.id}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Detalles de conexión (Host, Puerto, Usuario, Almacenamiento) usando InfoLine (common)
          if (isDesktop)
            Row(
              children: [
                Expanded(child: InfoLine(icon: Icons.dns_rounded, label: 'Host', value: instance.host)),
                const SizedBox(width: 16),
                Expanded(child: InfoLine(icon: Icons.numbers_rounded, label: 'Puerto', value: '${instance.port}')),
              ],
            )
          else ...[
            InfoLine(icon: Icons.dns_rounded, label: 'Host', value: instance.host),
            const SizedBox(height: 8),
            InfoLine(icon: Icons.numbers_rounded, label: 'Puerto', value: '${instance.port}'),
          ],
          const SizedBox(height: 8),
          if (isDesktop)
            Row(
              children: [
                Expanded(child: InfoLine(icon: Icons.storage_rounded, label: 'BD', value: instance.database)),
                const SizedBox(width: 16),
                Expanded(child: InfoLine(icon: Icons.person_rounded, label: 'Usuario', value: instance.username)),
              ],
            )
          else ...[
            InfoLine(icon: Icons.storage_rounded, label: 'BD', value: instance.database),
            const SizedBox(height: 8),
            InfoLine(icon: Icons.person_rounded, label: 'Usuario', value: instance.username),
          ],
          const SizedBox(height: 18),

          // Barra gráfica de almacenamiento consumido
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Almacenamiento ocupado', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  Text(
                    '${instance.storageUsed.toInt()} MB / ${instance.storageLimit.toInt()} MB',
                    style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: instance.storageUsed / instance.storageLimit,
                  backgroundColor: const Color(0xFFE0E7F0),
                  valueColor: AlwaysStoppedAnimation<Color>(style.color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Botones gráficos de acción: Encender/Apagar, Ver Credenciales, Eliminar
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // Botón de Ver Credenciales que abre CredentialsDialog
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CredentialsDialog(
                      instance: instance,
                      onMessage: onMessage,
                    ),
                  );
                },
                icon: const Icon(Icons.key_rounded, size: 16),
                label: const Text('Ver credenciales'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),

              // Botón para alternar estado (Detener / Iniciar)
              OutlinedButton.icon(
                onPressed: onToggleState,
                icon: Icon(
                  instance.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 16,
                ),
                label: Text(instance.isRunning ? 'Detener' : 'Iniciar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: instance.isRunning ? AppColors.orange : AppColors.green,
                  side: BorderSide(
                    color: instance.isRunning ? AppColors.orange : AppColors.green,
                  ),
                ),
              ),

              // Botón rojo de Eliminar instancia
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red, size: 20),
                tooltip: 'Eliminar instancia',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
