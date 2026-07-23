import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Componente de fila individual para visualizar un dato de credencial (Host, Puerto, etc.) con botón de copia.
/// ¿De dónde trae?: Consume AppColors de core/theme/app_colors.dart.
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de CredentialsDialog para construir el listado de datos.
class CredentialItem extends StatelessWidget {
  const CredentialItem({
    required this.label,   // Etiqueta del campo (ej. "Host", "Usuario")
    required this.value,   // Valor de la credencial (ej. "pg01.raftdb.dev")
    this.onCopy,           // Acción para copiar al portapapeles
    this.trailing,         // Widget opcional a la derecha (ej. grupo de botones para password)
    super.key,
  });

  final String label;
  final String value;
  final VoidCallback? onCopy;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta superior en letra pequeña
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          // Caja contenedora del valor con fondo gris tenue
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  // Texto seleccionable en tipografía estilo consola (monospace)
                  child: SelectableText(
                    value,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                // Botón gráfico de copiar a la derecha (o widget personalizado de la contraseña)
                trailing ??
                    IconButton(
                      tooltip: 'Copiar',
                      onPressed: onCopy,
                      icon: const Icon(
                        Icons.copy_rounded,
                        size: 18,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
