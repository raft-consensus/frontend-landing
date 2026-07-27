import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart'; // Common

/// ¿Qué hace?: Tarjeta con formulario para editar datos personales del usuario (Nombre, Email, Organización).
/// ¿De dónde trae?: Trae AppColors (core), DashboardCard y FieldLabel (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro del panel principal de AccountPage.
class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({
    required this.onMessage, // Callback para notificaciones snackbar
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  final _nameController = TextEditingController(text: 'Usuario Raft');
  final _emailController = TextEditingController(text: 'user@raftdb.dev');
  final _orgController = TextEditingController(text: 'Universidad Tecnológica');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _orgController.dispose();
    super.dispose();
  }

  void _save() {
    widget.onMessage('Perfil actualizado correctamente.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información Personal',
            style: TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Actualiza tu nombre completo, correo institucional y organización.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 20),

          const FieldLabel('Nombre completo'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline_rounded)),
          ),
          const SizedBox(height: 14),

          const FieldLabel('Correo electrónico'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined)),
          ),
          const SizedBox(height: 14),

          const FieldLabel('Organización / Universidad'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _orgController,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.school_outlined)),
          ),
          const SizedBox(height: 20),

          // Botón de guardar cambios
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_rounded, size: 16),
              label: const Text('Guardar cambios'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }
}
