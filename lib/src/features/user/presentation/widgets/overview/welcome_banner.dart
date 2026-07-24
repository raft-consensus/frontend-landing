import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Banner principal de bienvenida con degradado azul y accesos rápidos para crear BD o ver documentación.
/// ¿De dónde trae?: Consume AppColors de core/theme/app_colors.dart.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza en la parte superior de OverviewPage.
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    required this.onCreateDatabase,  // Callback para abrir el modal de crear BD
    required this.onGoDocumentation, // Callback para cambiar a la pestaña de documentación
    super.key,
  });

  final VoidCallback onCreateDatabase;
  final VoidCallback onGoDocumentation;

  @override
  Widget build(BuildContext context) {
    // Contenedor visual con gradiente elegante azul oscuro a azul brillante
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.navy,
            Color(0xFF0C4D96),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20071D45),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Insignia superior "PANEL DE CONTROL"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'PANEL DE CONTROL',
              style: TextStyle(
                color: AppColors.cyan,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Título de bienvenida
          const Text(
            '¡Hola de nuevo, Desarrollador!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Gestiona tus instancias de bases de datos relacionales y NoSQL en un solo lugar.',
            style: TextStyle(
              color: Color(0xFFB0D2F5),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Botones gráficos de acción rápida
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: onCreateDatabase,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Crear instancia'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  foregroundColor: AppColors.deepNavy,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                  )
                ),
              ),
              OutlinedButton.icon(
                onPressed: onGoDocumentation,
                icon: const Icon(Icons.description_outlined, size: 18),
                label: const Text('Ver guías de conexión'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF4A89C6)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
