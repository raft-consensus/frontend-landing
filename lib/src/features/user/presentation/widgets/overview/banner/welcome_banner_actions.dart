// ==========================================
// Qué hace: Contenido textual del banner de bienvenida (Badge, Saludo, Descripción y Botones de acción).
// Dónde se conecta: Consumido dentro de WelcomeBanner.
// De dónde trae datos: Recibe pillBg, pillTextColor, onCreateDatabase y onGoDocumentation.
// ==========================================

import 'package:flutter/material.dart';

/// Contenido textual y botones de acción rápida del banner de bienvenida
class WelcomeBannerActions extends StatelessWidget {
  const WelcomeBannerActions({
    required this.pillBg, // Fondo translúcido del badge
    required this.pillTextColor, // Color del texto del badge
    required this.onCreateDatabase, // Callback al crear nueva base de datos
    required this.onGoDocumentation, // Callback para ir a la documentación
    super.key,
  });

  final Color pillBg;
  final Color pillTextColor;
  final VoidCallback onCreateDatabase;
  final VoidCallback onGoDocumentation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Badge "PANEL DE CONTROL"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: pillBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'PANEL DE CONTROL',
            style: TextStyle(
              color: pillTextColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 2. Título de bienvenida
        const Text(
          '¡Hola de nuevo, Desarrollador!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),

        // 3. Subtítulo descriptivo
        const Text(
          'Gestiona tus instancias de bases de datos relacionales y NoSQL en un solo lugar.',
          style: TextStyle(
            color: Color(0xFFB0D2F5),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),

        // 4. Botones de acción rápida
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: onCreateDatabase,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('+ Crear Instancia'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2A9D8F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onGoDocumentation,
              icon: const Icon(Icons.article_outlined, size: 18),
              label: const Text('Ver guías de conexión'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                side: const BorderSide(color: Color(0xFF4A89C6)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
