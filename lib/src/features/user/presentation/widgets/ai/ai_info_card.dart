import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Tarjeta informativa al pie con detalles técnicos y políticas de uso de las API Keys del servicio de IA.
/// ¿De dónde trae datos?: Ingesta Theme.of(context) y AppColors.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye al final del ScrollView en AiServicesPage.
class AiInfoCard extends StatelessWidget {
  const AiInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Políticas y Uso de API Keys del Servicio de IA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: titleColor),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Las API Keys son generadas de forma única para tu usuario. No se permite la edición ni pausado; únicamente la creación o revocación.\n'
                  '• Cada API Key cuenta con un medidor de consumo de hasta 10,000 solicitudes impuestas por la Célula Proveedora. Al agotar el límite, genera una nueva clave.\n'
                  '• Envía tu clave en el encabezado HTTP: Authorization: Bearer <TU_API_KEY> para autenticar tus peticiones de IA.',
                  style: TextStyle(fontSize: 12, color: subtitleColor, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
