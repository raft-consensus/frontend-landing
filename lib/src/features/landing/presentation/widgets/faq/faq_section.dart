import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/faq/faq_tile.dart';

/// Sección visual de Preguntas Frecuentes (FAQ).
/// 
/// ¿Qué hace?: Muestra una lista de preguntas desplegables en un contenedor centralizado.
/// ¿De dónde recibe datos?: Lista inmutable de pares pregunta-respuesta.
/// ¿Hacia dónde va / Dónde se conecta?: Se incluye directamente en LandingScreen (landing_page.dart).
class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    const questions = [
      [
        '¿Raft DB es realmente gratuito?',
        'Sí. Está pensado para estudiantes y desarrolladores que necesitan '
            'bases de datos para aprendizaje, prototipos y pruebas.',
      ],
      [
        '¿Qué motores están disponibles?',
        'Puedes trabajar con MySQL, PostgreSQL, SQL Server y MongoDB.',
      ],
      [
        '¿Puedo conectarme desde cualquier lenguaje?',
        'Sí. Puedes utilizar Flutter, Node.js, Python, Java, C# y cualquier '
            'tecnología compatible con el motor seleccionado.',
      ],
      [
        '¿Puedo usarlo en producción?',
        'El servicio gratuito está orientado principalmente a educación, '
            'desarrollo y pruebas, no a cargas críticas de producción.',
      ],
    ];

    return SectionContainer(
      background: Colors.white,
      child: Column(
        children: [
          // Título reutilizable de la sección
          const SectionTitle(
            eyebrow: 'PREGUNTAS FRECUENTES',
            title: '¿Tienes alguna duda?',
            subtitle:
                'Estas son algunas de las preguntas más comunes sobre Raft DB.',
          ),
          const SizedBox(height: 35),

          // Acordeón de preguntas restringido a 850px de ancho para mejor legibilidad
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              children: questions
                  .map(
                    (q) => FaqTile(
                      question: q[0],
                      answer: q[1],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
