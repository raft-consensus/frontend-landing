import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/domain/entities/databse_engine.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_banner.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/engine_picker_grid.dart'; // Dialogs

/// ¿Qué hace?: Modal emergente principal para la creación de una nueva base de datos.
/// ¿De dónde trae?: Trae AppColors (core), entidades de dominio (domain), FieldLabel/InfoBanner (common) y EnginePickerGrid (dialogs).
/// ¿Hacia dónde va / Cómo se conecta?: Se abre desde DashboardTopbar o WelcomeBanner mediante showDialog().
class CreateDatabaseDialog extends StatefulWidget {
  const CreateDatabaseDialog({super.key});

  @override
  State<CreateDatabaseDialog> createState() => _CreateDatabaseDialogState();
}

class _CreateDatabaseDialogState extends State<CreateDatabaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final List<DatabaseEngine> _engines = const [
    DatabaseEngine(name: 'PostgreSQL', version: '16', port: 5432, color: Color(0xFF3977A8), icon: Icons.storage_rounded),
    DatabaseEngine(name: 'MySQL', version: '8.0', port: 3306, color: AppColors.blue, icon: Icons.dns_rounded),
    DatabaseEngine(name: 'SQL Server', version: '2022', port: 1433, color: AppColors.red, icon: Icons.table_chart_rounded),
    DatabaseEngine(name: 'MongoDB', version: '7.0', port: 27017, color: AppColors.green, icon: Icons.eco_rounded),
  ];

  int _selectedEngine = 0;
  bool _creating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    // Dispara el estado de carga visual en el botón
    setState(() => _creating = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final engine = _engines[_selectedEngine];
    final slug = _nameController.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final random = math.Random().nextInt(80) + 10;

    // Cierra el modal retornando la instancia creada a la página
    Navigator.pop(
      context,
      DatabaseInstance(
        id: 'db-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        engine: engine.name,
        version: engine.version,
        database: '${slug}_db',
        username: 'raft_user_$random',
        host: '${engine.name.toLowerCase().replaceAll(' ', '')}$random.raftdb.dev',
        port: engine.port,
        storageUsed: 0,
        storageLimit: 512,
        createdAt: '23 Jul 2026',
      ),
    );
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
                // Cabecera con icono "+" y botón de cerrar "X"
                Row(
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
                          Text('Crear nueva instancia', style: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w900)),
                          Text('Selecciona el motor para tu proyecto.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _creating ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // Uso de Widget Reutilizable: FieldLabel (common)
                const FieldLabel('Nombre de la instancia'),
                const SizedBox(height: 8),

                // Campo gráfico de entrada de texto
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Ejemplo: proyecto-universidad',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Ingresa un nombre para la instancia.';
                    if (value.trim().length < 3) return 'El nombre debe tener al menos 3 caracteres.';
                    return null;
                  },
                ),
                const SizedBox(height: 22),

                // Uso de Widget Reutilizable: FieldLabel (common)
                const FieldLabel('Motor de base de datos'),
                const SizedBox(height: 12),

                // Uso de Sub-Widget extraído: EnginePickerGrid (dialogs)
                EnginePickerGrid(
                  engines: _engines,
                  selectedIndex: _selectedEngine,
                  disabled: _creating,
                  onSelectEngine: (index) => setState(() => _selectedEngine = index),
                ),
                const SizedBox(height: 23),

                // Uso de Widget Reutilizable: InfoBanner (common)
                const InfoBanner(
                  message: 'La instancia gratuita incluye 512 MB de almacenamiento y acceso remoto.',
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.blue,
                ),
                const SizedBox(height: 25),

                // Botones de acción inferiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _creating ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 10),
                    // Botón principal de submit con loader animado
                    FilledButton.icon(
                      onPressed: _creating ? null : _create,
                      icon: _creating
                          ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.rocket_launch_rounded),
                      label: Text(_creating ? 'Creando...' : 'Crear instancia'),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
