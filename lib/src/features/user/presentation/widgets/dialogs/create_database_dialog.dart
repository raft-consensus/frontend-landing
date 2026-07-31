import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/databse_engine.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_banner.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/engine_picker_grid.dart';

/// ¿Qué hace?: Modal emergente modular para la creación de una nueva base de datos.
/// ¿De dónde trae?: Trae AppColors (core), DatabaseEngine (domain) y widgets comunes (FieldLabel, InfoBanner, EnginePickerGrid).
/// ¿Dónde se conecta?: Se abre desde `DashboardPage` mediante `showDialog()`.
class CreateDatabaseDialog extends StatefulWidget {
  const CreateDatabaseDialog({super.key});

  @override
  State<CreateDatabaseDialog> createState() => _CreateDatabaseDialogState();
}

class _CreateDatabaseDialogState extends State<CreateDatabaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  /// Lista de motores ofrecidos (SQL Server activo por defecto en esta fase)
  final List<DatabaseEngine> _engines = const [
    DatabaseEngine(
      name: 'SQL Server',
      version: '2022',
      port: 1433,
      color: AppColors.red,
      icon: Icons.table_chart_rounded,
      isAvailable: true, // Motor activo en esta fase
    ),
    DatabaseEngine(
      name: 'PostgreSQL',
      version: '16',
      port: 5432,
      color: Color(0xFF3977A8),
      icon: Icons.storage_rounded,
      isAvailable: false, // Próxima fase
    ),
    DatabaseEngine(
      name: 'MySQL',
      version: '8.0',
      port: 3306,
      color: AppColors.blue,
      icon: Icons.dns_rounded,
      isAvailable: false, // Próxima fase
    ),
    DatabaseEngine(
      name: 'MongoDB',
      version: '7.0',
      port: 27017,
      color: AppColors.green,
      icon: Icons.eco_rounded,
      isAvailable: false, // Próxima fase
    ),
  ];

  int _selectedEngine = 0; // SQL Server seleccionado por defecto
  bool _creating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Valida el formulario y retorna los datos seleccionados a la pantalla anterior
  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _creating = true);
    final engine = _engines[_selectedEngine];

    // Cierra el modal devolviendo el mapa con el nombre y motor elegido
    Navigator.pop(context, {
      'name': _nameController.text.trim(),
      'engine': engine.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                // 1. Sub-widget de cabecera con botón de cierre
                _DialogHeader(creating: _creating),
                const SizedBox(height: 26),

                // 2. Sub-widget de entrada del nombre
                _InstanceNameInput(controller: _nameController),
                const SizedBox(height: 22),

                // 3. Etiqueta y grilla de selección de motor
                const FieldLabel('Motor de base de datos'),
                const SizedBox(height: 12),
                EnginePickerGrid(
                  engines: _engines,
                  selectedIndex: _selectedEngine,
                  disabled: _creating,
                  onSelectEngine: (index) =>
                      setState(() => _selectedEngine = index),
                ),
                const SizedBox(height: 23),

                // 4. Banner informativo de capacidad
                const InfoBanner(
                  message:
                      'La instancia gratuita incluye 512 MB de almacenamiento y acceso remoto.',
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.blue,
                ),
                const SizedBox(height: 25),

                // 5. Sub-widget de acciones (Cancelar / Crear)
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
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFE0EEFC),
          child: Icon(Icons.add_rounded, color: AppColors.blue),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crear nueva instancia',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Selecciona el motor para tu proyecto.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: creating ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

/// Sub-widget extraído: Campo de texto para ingresar el nombre de la instancia
class _InstanceNameInput extends StatelessWidget {
  const _InstanceNameInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Nombre de la instancia'),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ejemplo: proyecto-universidad',
            prefixIcon: Icon(Icons.edit_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa un nombre para la instancia.';
            }
            if (value.trim().length < 3) {
              return 'El nombre debe tener al menos 3 caracteres.';
            }
            return null;
          },
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
              : const Icon(Icons.rocket_launch_rounded),
          label: Text(creating ? 'Creando...' : 'Crear instancia'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
