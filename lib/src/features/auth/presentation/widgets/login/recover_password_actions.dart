import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Barra de botones de acción para el diálogo de recuperación de contraseña.
/// 
/// ¿Qué hace?: Muestra los botones de Cancelar y Enviar, adaptándose al estado de carga.
/// ¿De dónde recibe datos?: Del estado `isLoading` y las funciones `onCancel` y `onSend`.
/// ¿Hacia dónde se conecta?: Dispara el cierre del modal o la ejecución del envío del formulario.
class RecoverPasswordActions extends StatelessWidget {
  const RecoverPasswordActions({
    required this.isLoading,
    required this.onCancel,
    required this.onSend,
    super.key,
  });

  /// Determina si se muestra el indicador de carga o el texto del botón
  final bool isLoading;

  /// Callback para cancelar la operación y cerrar el modal
  final VoidCallback onCancel;

  /// Callback para procesar el envío de la solicitud
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Botón Cancelar
        TextButton(
          onPressed: isLoading ? null : onCancel,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF687A91),
          ),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 12),
        // Botón Enviar instrucciones
        ElevatedButton(
          onPressed: isLoading ? null : onSend,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Enviar instrucciones',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ],
    );
  }
}
