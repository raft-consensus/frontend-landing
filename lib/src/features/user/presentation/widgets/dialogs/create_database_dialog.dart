import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/databse_engine.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_banner.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/engine_picker_grid.dart'; // Dialogs

/// ¿Qué hace?: Modal emergente modular para la creación de una nueva base de datos con soporte Día/Noche.
/// ¿De dónde trae datos?: Ingesta AppColors, DatabaseEngine y widgets de diálogo.
/// ¿Dónde se conecta?: Se abre desde DashboardPage mediante showDialog().
class CreateDatabaseDialog extends StatefulWidget {
  const CreateDatabaseDialog({super.key});

  @override
  State<CreateDatabaseDialog> createState() => _CreateDatabaseDialogState();
}

class _CreateDatabaseDialogState extends State<CreateDatabaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  /// Lista de motores ofrecidos
  final List<DatabaseEngine> _engines = const [
    DatabaseEngine(
      name: 'SQL Server',
      version: '2022',
      port: 1433,
      color: AppColors.sqlServerDay,
      icon: Icons.table_chart_rounded,
      isAvailable: true,
    ),
    DatabaseEngine(
      name: 'PostgreSQL',
      version: '16',
      port: 5432,
      color: AppColors.postgresDay,
      icon: Icons.storage_rounded,
      isAvailable: true,
    ),
    DatabaseEngine(
      name: 'MySQL',
      version: '8.0',
      port: 3306,
      color: AppColors.mysqlDay,
      icon: Icons.dns_rounded,
      isAvailable: true,
    ),
    DatabaseEngine(
      name: 'MongoDB',
      version: '7.0',
      port: 27017,
      color: AppColors.mongoDbDay,
      icon: Icons.eco_rounded,
      isAvailable: true,
    ),
  ];

  int _selectedEngine = 0;
  bool _creating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _create() {
    setState(() => _creating = true);
    final engine = _engines[_selectedEngine];

    Navigator.pop(context, {
      'name': _nameController.text.trim(),
      'engine': engine.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Cabecera del modal
                _DialogHeader(creating: _creating),
                const SizedBox(height: 26),

                // 2. Selección de motor
                const FieldLabel('Selecciona el motor de base de datos'),
                const SizedBox(height: 12),
                EnginePickerGrid(
                  engines: _engines,
                  selectedIndex: _selectedEngine,
                  disabled: _creating,
                  onSelectEngine: (index) =>
                      setState(() => _selectedEngine = index),
                ),
                const SizedBox(height: 23),

                // 3. Banner informativo
                InfoBanner(
                  message:
                      'El identificador y las credenciales de acceso son asignados automáticamente de forma segura por el servidor.',
                  icon: Icons.info_outline_rounded,
                  iconColor: theme.colorScheme.primary,
                ),
                const SizedBox(height: 25),

                // 4. Botones de acción
                _DialogActions(
                  creating: _creating,
                  onCreate: _create,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sub-widget extraído: Encabezado del modal con icono y botón de cierre
class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.creating});

  final bool creating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.add_rounded, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crear nueva instancia',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Elige el motor adecuado para tu proyecto.',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: creating ? null : () => Navigator.pop(context),
          icon: Icon(
            Icons.close_rounded,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}

/// Sub-widget extraído: Botones de acción inferior (Cancelar / Crear)
class _DialogActions extends StatelessWidget {
  const _DialogActions({
    required this.creating,
    required this.onCreate,
  });

  final bool creating;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: creating ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: creating ? null : onCreate,
          icon: creating
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.rocket_launch_rounded, size: 18),
          label: Text(creating ? 'Creando...' : 'Crear instancia'),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
