// ==========================================
// Que hace: Tarjeta informativa concisa y estilizada que resume la configuracion del Base URL, modelo de IA y las acciones de claves.
// De donde trae datos: Ingesta Theme.of(context) y AppColors.
// Hacia donde va / Como se conecta: Se incluye al final del ScrollView en AiServicesPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Componente de tarjeta informativa estilizada para el uso de API Keys de IA
class AiInfoCard extends StatelessWidget {
  /// Constructor constante
  const AiInfoCard({super.key});

  /// Base URL oficial expuesta para el cliente
  static const String baseUrl = 'https://api.coderhivex.com/v1';

  /// Nombre del modelo soportado por la plataforma
  static const String modelName = 'llama-8b-nvidia';

  @override
  Widget build(BuildContext context) {
    // Obtiene el tema actual de la aplicacion
    final theme = Theme.of(context);
    // Determina si el tema visual activo es oscuro
    final isDark = theme.brightness == Brightness.dark;

    // Color para los titulos de la tarjeta segun el tema
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    // Color para el texto descriptivo segun el tema
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    // Color de fondo para destacar la caja de configuracion del endpoint
    final badgeBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

    return Container(
      // Margen interno de la tarjeta
      padding: const EdgeInsets.all(16),
      // Estilo de bordes y fondo
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Encabezado principal de la tarjeta
          Row(
            children: [
              Icon(Icons.terminal_rounded, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 10),
              Text(
                'Como funciona tu API Key Proxy de IA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Caja visual destacada con el Base URL y el Modelo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila con Base URL y boton interactivo de copiar
                Row(
                  children: [
                    Text(
                      'Base URL: ',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: titleColor),
                    ),
                    Expanded(
                      child: SelectableText(
                        baseUrl,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: baseUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Base URL copiada al portapapeles'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.copy_rounded, size: 15, color: subtitleColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Fila con el Modelo soportado
                Row(
                  children: [
                    Text(
                      'Modelo: ',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: titleColor),
                    ),
                    Text(
                      modelName,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Nota corta de compatibilidad
          Text(
            'Compatible 100% con el estandar OpenAI (Python, LangChain, Cursor, VS Code).',
            style: TextStyle(fontSize: 12, color: subtitleColor),
          ),
          const SizedBox(height: 12),

          // 4. Filas estructuradas para las acciones de Rotar y Revocar
          Row(
            children: [
              Icon(Icons.refresh_rounded, size: 15, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                    children: [
                      TextSpan(
                        text: 'Rotar: ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      const TextSpan(
                        text: 'Genera un nuevo secreto conservando tus estadisticas de consumo.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.block_rounded, size: 15, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                    children: [
                      TextSpan(
                        text: 'Revocar: ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      const TextSpan(
                        text: 'Desactiva la clave permanentemente (retorna HTTP 401).',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
