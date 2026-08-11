import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart';

/// Formulario para cambio de contraseña de usuario.
/// 
/// ¿Qué hace?: Muestra las entradas de contraseña actual/nueva y el botón submit interactivo.
/// ¿De dónde recibe datos?: Controladores de texto, estado de carga y callback de guardado.
/// ¿Hacia dónde se conecta?: Orquestado por SecurityCard.
class SecurityPasswordForm extends StatelessWidget {
  const SecurityPasswordForm({
    required this.currentPassController,
    required this.newPassController,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController currentPassController;
  final TextEditingController newPassController;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Contraseña actual'),
        const SizedBox(height: 6),
        TextFormField(
          controller: currentPassController,
          obscureText: true,
          enabled: !isLoading,
          decoration: const InputDecoration(
            hintText: 'Ingresa tu clave actual',
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
        ),
        const SizedBox(height: 14),

        const FieldLabel('Nueva contraseña'),
        const SizedBox(height: 6),
        TextFormField(
          controller: newPassController,
          obscureText: true,
          enabled: !isLoading,
          decoration: const InputDecoration(
            hintText: 'Mínimo 8 caracteres',
            prefixIcon: Icon(Icons.key_outlined),
          ),
        ),
        const SizedBox(height: 20),

        // Botón de actualización ajustado al tema visual
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: isLoading ? null : onSubmit,
            icon: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.shield_rounded, size: 16),
            label: Text(isLoading ? 'Actualizando...' : 'Actualizar contraseña'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
