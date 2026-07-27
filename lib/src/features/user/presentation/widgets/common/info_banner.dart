import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Banner decorativo responsivo para mostrar avisos informativos, alertas o consejos en cuadros coloreados.
/// ¿De dónde trae?: Consume AppColors de core/theme/app_colors.dart.
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de CreateDatabaseDialog y CredentialsDialog para mostrar alertas.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    required this.message,         // Texto informativo a renderizar en pantalla
    required this.icon,            // Icono ilustrativo que acompaña la alerta
    this.backgroundColor,          // Fondo opcional (por defecto azul pastel)
    this.borderColor,              // Borde opcional
    this.iconColor = AppColors.blue, // Color del icono (por defecto azul de core)
    this.textColor = AppColors.text, // Color del texto (por defecto texto oscuro de core)
    super.key,
  });

  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    // Renderizado del contenedor visual con esquinas redondeadas
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF0F7FF), // Fondo tenue pastel
        borderRadius: BorderRadius.circular(14),           // Curvatura de bordes de 14px
        border: Border.all(
          color: borderColor ?? const Color(0xFFD4E8FC),   // Borde sutil delimitador
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor), // Icono ilustrativo a la izquierda
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                height: 1.45, // Altura de línea para lectura cómoda
              ),
            ),
          ),
        ],
      ),
    );
  }
}
