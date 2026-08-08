import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/faq/faq_tile.dart';

/// ¿Qué hace?: Sección visual de Preguntas Frecuentes (FAQ) con acordeón desplegable multiservicio.
/// ¿De dónde trae datos?: Lista inmutable interna de 6 pares pregunta-respuesta sobre BDs, DNS, IA y N8N.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye directamente en LandingPage.
class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 6 Preguntas frecuentes mixtas (BDs, DNS, IA, N8N, Gratuidad, Producción)
    const questions = [
      [
        '¿Raft Cloud es realmente gratuito?',
        'Sí. Está pensado para estudiantes y desarrolladores que necesitan '
            'bases de datos, DNS, IA y automatización para aprendizaje y proyectos.',
      ],
      [
        '¿Qué servicios están disponibles?',
        'Puedes utilizar Bases de Datos (MySQL, Postgres, SQL Server, MongoDB), '
            'Gestión de DNS con SSL, API Keys de IA y Workflows de n8n.',
      ],
      [
        '¿Puedo conectarme desde cualquier lenguaje?',
        'Sí. Puedes utilizar Flutter, Node.js, Python, Java, C# y cualquier '
            'tecnología compatible con los servicios activados.',
      ],
      [
        '¿Cómo funciona el servicio de DNS?',
        'Puedes vincular subdominios bajo coderhivex.com con certificados SSL automáticos.',
      ],
      [
        '¿Qué incluye el servicio de Inteligencia Artificial?',
        'Generación de API Keys para consumir modelos de lenguaje directamente en tus apps.',
      ],
      [
        '¿Puedo usarlo en producción?',
        'El servicio gratuito está orientado a educación, desarrollo y pruebas, '
            'no a cargas críticas de producción masiva.',
      ],
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SectionContainer(
      background: isDark ? AppColors.nightSurface : const Color(0xFFF0F4F8),
      child: Column(
        children: [
          // 2. Título reutilizable de la sección
          const SectionTitle(
            eyebrow: 'PREGUNTAS FRECUENTES',
            title: '¿Tienes alguna duda?',
            subtitle:
                'Respuestas a las preguntas más comunes sobre Raft Cloud.',
          ),
          const SizedBox(height: 35),

          // 3. Acordeón de preguntas restringido a 850px para óptima legibilidad
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              children: questions
                  .map((q) => FaqTile(question: q[0], answer: q[1]))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
