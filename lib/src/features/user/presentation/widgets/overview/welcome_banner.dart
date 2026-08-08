import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Banner de bienvenida con gradiente marino, saludo, botones de acción e ilustración de la balsa al 100% de altura.
/// ¿De dónde trae datos?: Ingesta Theme.of(context) para conmutar colores y balsa entre Raft Day y Raft Night.
/// ¿Hacia dónde va / Cómo se conecta?: Renderizado en la parte superior de OverviewPage.
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    required this.onCreateDatabase,  // Callback para abrir el modal de creación de BD
    required this.onGoDocumentation, // Callback para ir a la pestaña de documentación
    super.key,
  });

  final VoidCallback onCreateDatabase;
  final VoidCallback onGoDocumentation;

  @override
  Widget build(BuildContext context) {
    // 1. Determina responsividad (Escritorio >= 900px) y modo de tema (Día vs Noche)
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. Selecciona la paleta de gradientes según Raft Day o Raft Night
    final gradientColors = isDark
        ? [const Color(0xFF0A1E32), const Color(0xFF132F4C)]
        : [const Color(0xFF092648), AppColors.dayPrimary];

    final pillBg = isDark
        ? AppColors.nightSecondary.withValues(alpha: 0.20)
        : AppColors.daySecondary.withValues(alpha: 0.25);

    final pillTextColor = isDark ? AppColors.nightSecondary : const Color(0xFF59B9E6);

    return Container(
      // Padding del banner optimizado para permitir que la balsa llene la altura sin salirse
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28 : 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Sección Izquierda: 60% del ancho del banner para texto y botones
          Expanded(
            flex: 3,
            child: _BannerTextContent(
              pillBg: pillBg,
              pillTextColor: pillTextColor,
              onCreateDatabase: onCreateDatabase,
              onGoDocumentation: onGoDocumentation,
            ),
          ),

          // 2. Sección Derecha: 40% del ancho restante con margen para despegar la balsa del borde derecho
          if (isDesktop) ...[
            const SizedBox(width: 16),
            const Expanded(
              flex: 2,
              child: _BannerIllustration(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Sub-widget privado 1: Badge, saludo de bienvenida y botones de acción rápida
class _BannerTextContent extends StatelessWidget {
  const _BannerTextContent({
    required this.pillBg,
    required this.pillTextColor,
    required this.onCreateDatabase,
    required this.onGoDocumentation,
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

/// Sub-widget privado 2: Balsa oficial con margen derecho para despegarla del borde y centrarla
class _BannerIllustration extends StatelessWidget {
  const _BannerIllustration();

  @override
  Widget build(BuildContext context) {
    // 1. Detecta si el tema es oscuro para seleccionar logo_night.png o logo_light.png
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoPath = isDark ? 'lib/src/img/in/logo_night.png' : 'lib/src/img/in/logo_light.png';

    return Padding(
      padding: const EdgeInsets.only(right: 28), // Despega la balsa del borde derecho y la acerca al centro
      child: SizedBox(
        height: 175,
        child: Image.asset(
          logoPath,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'lib/src/img/image_logo_02.png',
            height: 175,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.sailing_rounded,
              size: 70,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
