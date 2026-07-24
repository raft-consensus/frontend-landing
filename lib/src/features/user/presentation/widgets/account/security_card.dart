import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart'; // Common

/// ¿Qué hace?: Tarjeta con formulario para cambio de contraseña y ajustes de seguridad de la cuenta.
/// ¿De dónde trae?: Trae AppColors (core), DashboardCard y FieldLabel (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro del panel principal de AccountPage.
class SecurityCard extends StatefulWidget {
  const SecurityCard({
    required this.onMessage, // Callback para notificaciones snackbar
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  State<SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends State<SecurityCard> {
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    if (_currentPassController.text.isEmpty || _newPassController.text.isEmpty) {
      widget.onMessage('Ingresa tu contraseña actual y la nueva.', success: false);
      return;
    }
    _currentPassController.clear();
    _newPassController.clear();
    widget.onMessage('Contraseña actualizada con éxito.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seguridad y Contraseña',
            style: TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Mantén tu cuenta protegida cambiando tu clave periódicamente.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 20),

          const FieldLabel('Contraseña actual'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _currentPassController,
            obscureText: true,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.lock_outline_rounded)),
          ),
          const SizedBox(height: 14),

          const FieldLabel('Nueva contraseña'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _newPassController,
            obscureText: true,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.key_outlined)),
          ),
          const SizedBox(height: 20),

          // Botón cambiar contraseña
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _updatePassword,
              icon: const Icon(Icons.shield_outlined, size: 16),
              label: const Text('Actualizar contraseña'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
