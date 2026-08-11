import 'package:flutter/material.dart';

/// Componente de encabezado para el diálogo de recuperación de contraseña.
/// 
/// ¿Qué hace?: Renderiza el título, subtítulo informativo y el botón para cerrar el modal.
/// ¿De dónde recibe datos?: Recibe el estado `isLoading` y el callback `onClose` desde el modal padre.
/// ¿Hacia dónde se conecta?: Notifica al modal cuando el usuario presiona la 'X' para cerrar.
class RecoverPasswordHeader extends StatelessWidget {
  const RecoverPasswordHeader({
    required this.isLoading,
    required this.onClose,
    super.key,
  });

  /// Indica si hay una operación asíncrona en curso para deshabilitar el botón de cierre
  final bool isLoading;

  /// Callback para cerrar el diálogo modal
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila del título y botón de cierre
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recuperar contraseña',
              style: TextStyle(
                color: Color(0xFF10233F),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            IconButton(
              onPressed: isLoading ? null : onClose,
              icon: const Icon(Icons.close_rounded, color: Color(0xFF687A91)),
              tooltip: 'Cerrar',
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Subtítulo con instrucciones
        const Text(
          'Ingresa tu correo electrónico registrado y te enviaremos las instrucciones para restablecer tu contraseña.',
          style: TextStyle(
            color: Color(0xFF687A91),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
