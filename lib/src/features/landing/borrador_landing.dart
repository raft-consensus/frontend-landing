import 'package:flutter/material.dart';

void main() {
  runApp(const RaftDbApp());
}

class RaftDbApp extends StatelessWidget {
  const RaftDbApp({super.key});

  static const navy = Color(0xFF061D4F);
  static const blue = Color(0xFF0878D1);
  static const cyan = Color(0xFF0CC7C4);
  static const background = Color(0xFFF4F9FF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raft DB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          primary: navy,
          secondary: cyan,
          surface: Colors.white,
        ),
        fontFamily: 'Arial',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 58,
            fontWeight: FontWeight.w900,
            height: 1.04,
            color: navy,
          ),
          headlineLarge: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w900,
            color: navy,
          ),
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
          bodyLarge: TextStyle(
            fontSize: 17,
            height: 1.65,
            color: Color(0xFF52647C),
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            height: 1.55,
            color: Color(0xFF607189),
          ),
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NavigationBarSection(),
              HeroSection(),
              DatabaseSection(),
              BenefitsSection(),
              HowItWorksSection(),
              DashboardSection(),
              UseCasesSection(),
              FaqSection(),
              FinalCtaSection(),
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationBarSection extends StatelessWidget {
  const NavigationBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.96),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 850;

              return Row(
                children: [
                  const RaftLogo(),
                  const Spacer(),
                  if (desktop) ...[
                    const NavLink('Bases de datos'),
                    const NavLink('Beneficios'),
                    const NavLink('Cómo funciona'),
                    const NavLink('FAQ'),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Iniciar sesión'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: RaftDbApp.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 18,
                        ),
                      ),
                      child: const Text('Crear cuenta'),
                    ),
                  ] else
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_rounded),
                      color: RaftDbApp.navy,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class RaftLogo extends StatelessWidget {
  const RaftLogo({super.key, this.light = false});

  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : RaftDbApp.navy;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [RaftDbApp.cyan, RaftDbApp.blue],
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.sailing_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Raft',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 3),
        const Text(
          'DB',
          style: TextStyle(
            color: RaftDbApp.cyan,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class NavLink extends StatelessWidget {
  const NavLink(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: RaftDbApp.navy,
        padding: const EdgeInsets.symmetric(horizontal: 13),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF2FCFF),
            Color(0xFFEAF4FF),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: Opacity(
              opacity: 0.22,
              child: WaveBackground(),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 72, 24, 90),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = constraints.maxWidth > 850;

                    final content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Pill(
                          icon: Icons.school_rounded,
                          label: 'PARA ESTUDIANTES Y DESARROLLADORES',
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Bases de datos\ngratuitas para\nconstruir.',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: desktop ? 58 : 42,
                              ),
                        ),
                        const SizedBox(height: 22),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 590),
                          child: const Text(
                            'Despliega MySQL, PostgreSQL, SQL Server y '
                            'MongoDB en pocos minutos. Practica, prueba y '
                            'conecta tus proyectos sin configuraciones complejas.',
                            style: TextStyle(
                              color: Color(0xFF52647C),
                              fontSize: 18,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.rocket_launch_rounded),
                              label: const Text('Crear base de datos gratis'),
                              style: FilledButton.styleFrom(
                                backgroundColor: RaftDbApp.navy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 20,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_circle_outline),
                              label: const Text('Cómo funciona'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: RaftDbApp.navy,
                                side: const BorderSide(
                                  color: Color(0xFFBCCCE0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 27),
                        const Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          children: [
                            MiniBenefit('Sin tarjeta'),
                            MiniBenefit('Configuración rápida'),
                            MiniBenefit('Entorno seguro'),
                          ],
                        ),
                      ],
                    );

                    if (!desktop) {
                      return Column(
                        children: [
                          content,
                          const SizedBox(height: 50),
                          const RaftIllustration(),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(flex: 11, child: content),
                        const SizedBox(width: 50),
                        const Expanded(
                          flex: 9,
                          child: RaftIllustration(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFE4FAFA),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFB6EEEC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: const Color(0xFF008F91)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF007D80),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MiniBenefit extends StatelessWidget {
  const MiniBenefit(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF16AF74),
          size: 19,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF40536A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class RaftIllustration extends StatelessWidget {
  const RaftIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(42),
        border: Border.all(color: const Color(0xFFDCE9F5)),
        boxShadow: [
          BoxShadow(
            color: RaftDbApp.navy.withOpacity(0.12),
            blurRadius: 45,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 35,
            right: 35,
            child: Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                color: Color(0xFFE9FBFB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 76,
            child: Container(
              width: 12,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF8D552C),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 82,
            left: 118,
            right: 52,
            child: ClipPath(
              clipper: SailClipper(),
              child: Container(
                height: 205,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFF4EBDD)],
                  ),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Raft\nDB',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: RaftDbApp.navy,
                        fontSize: 42,
                        height: 0.9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 48,
            bottom: 96,
            child: Column(
              children: const [
                ServerDisk(color: RaftDbApp.cyan),
                ServerDisk(color: RaftDbApp.blue),
                ServerDisk(color: Color(0xFF7047E8)),
                ServerDisk(color: Color(0xFF20B95A)),
              ],
            ),
          ),
          Positioned(
            left: 62,
            right: 37,
            bottom: 70,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF8D552C),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: RaftDbApp.navy,
                  width: 5,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Icon(
              Icons.waves_rounded,
              color: RaftDbApp.blue,
              size: 85,
            ),
          ),
        ],
      ),
    );
  }
}

class ServerDisk extends StatelessWidget {
  const ServerDisk({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 40,
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.72), color],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RaftDbApp.navy, width: 4),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(radius: 3, backgroundColor: Colors.white),
          SizedBox(width: 5),
          CircleAvatar(radius: 3, backgroundColor: Colors.white),
        ],
      ),
    );
  }
}

class SailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.85, 0)
      ..quadraticBezierTo(
        size.width,
        size.height * 0.45,
        size.width * 0.72,
        size.height,
      )
      ..lineTo(0, size.height * 0.90)
      ..quadraticBezierTo(
        size.width * 0.14,
        size.height * 0.45,
        0,
        0,
      )
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WavePainter(),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = RaftDbApp.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 6; i++) {
      final y = size.height * 0.72 + (i * 25);
      final path = Path()..moveTo(0, y);

      path.cubicTo(
        size.width * 0.25,
        y - 80,
        size.width * 0.35,
        y + 80,
        size.width * 0.55,
        y,
      );

      path.cubicTo(
        size.width * 0.75,
        y - 80,
        size.width * 0.85,
        y + 60,
        size.width,
        y,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DatabaseSection extends StatelessWidget {
  const DatabaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'MOTORES DISPONIBLES',
            title: 'Trabaja con tus bases de datos favoritas',
            subtitle:
                'Crea una instancia y recibe los datos de conexión para comenzar.',
          ),
          const SizedBox(height: 42),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width > 950
                  ? (width - 54) / 4
                  : width > 580
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  DatabaseCard(
                    width: cardWidth,
                    name: 'MySQL',
                    type: 'Base de datos SQL',
                    color: const Color(0xFF0878D1),
                    icon: Icons.dns_rounded,
                  ),
                  DatabaseCard(
                    width: cardWidth,
                    name: 'PostgreSQL',
                    type: 'Base de datos SQL',
                    color: const Color(0xFF326FA4),
                    icon: Icons.storage_rounded,
                  ),
                  DatabaseCard(
                    width: cardWidth,
                    name: 'SQL Server',
                    type: 'Base de datos SQL',
                    color: const Color(0xFFE44545),
                    icon: Icons.table_chart_rounded,
                  ),
                  DatabaseCard(
                    width: cardWidth,
                    name: 'MongoDB',
                    type: 'Base de datos NoSQL',
                    color: const Color(0xFF19A85B),
                    icon: Icons.eco_rounded,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class DatabaseCard extends StatelessWidget {
  const DatabaseCard({
    required this.width,
    required this.name,
    required this.type,
    required this.color,
    required this.icon,
    super.key,
  });

  final double width;
  final String name;
  final String type;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE0EAF4)),
        boxShadow: [
          BoxShadow(
            color: RaftDbApp.navy.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color, size: 27),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F9F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '● Disponible',
                  style: TextStyle(
                    color: Color(0xFF12864E),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 5),
          Text(type),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Crear instancia'),
            ),
          ),
        ],
      ),
    );
  }
}

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const benefits = [
      BenefitData(
        Icons.bolt_rounded,
        'Creación rápida',
        'Obtén una base de datos y sus credenciales en pocos pasos.',
        Color(0xFFFFB020),
      ),
      BenefitData(
        Icons.shield_rounded,
        'Acceso seguro',
        'Credenciales individuales y aislamiento entre instancias.',
        Color(0xFF0878D1),
      ),
      BenefitData(
        Icons.school_rounded,
        'Ideal para aprender',
        'Practica consultas, modelado, APIs, migraciones y conexiones.',
        Color(0xFF7047E8),
      ),
      BenefitData(
        Icons.construction_rounded,
        'Herramientas de prueba',
        'Valida conexiones y revisa el estado de todos tus servicios.',
        Color(0xFF0BB6B2),
      ),
      BenefitData(
        Icons.hub_rounded,
        'Múltiples motores',
        'Selecciona el motor que mejor se adapte a cada proyecto.',
        Color(0xFFEA4A61),
      ),
      BenefitData(
        Icons.dashboard_rounded,
        'Panel centralizado',
        'Administra instancias, credenciales y disponibilidad.',
        Color(0xFF19A85B),
      ),
    ];

    return SectionContainer(
      background: const Color(0xFF061D4F),
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'BENEFICIOS',
            title: 'Todo lo necesario para comenzar',
            subtitle:
                'Olvídate de instalaciones complejas y concéntrate en aprender.',
            light: true,
          ),
          const SizedBox(height: 42),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width > 900
                  ? (width - 40) / 3
                  : width > 580
                      ? (width - 20) / 2
                      : width;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: benefits
                    .map(
                      (item) => BenefitCard(
                        width: cardWidth,
                        data: item,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BenefitData {
  const BenefitData(this.icon, this.title, this.description, this.color);

  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

class BenefitCard extends StatelessWidget {
  const BenefitCard({
    required this.width,
    required this.data,
    super.key,
  });

  final double width;
  final BenefitData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 51,
            height: 51,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(data.icon, color: data.color),
          ),
          const SizedBox(height: 19),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: const TextStyle(
              color: Color(0xFFB8C8DD),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      StepData(
        '01',
        Icons.person_add_alt_1_rounded,
        'Crea tu cuenta',
        'Regístrate gratuitamente como estudiante o desarrollador.',
      ),
      StepData(
        '02',
        Icons.storage_rounded,
        'Elige un motor',
        'Selecciona MySQL, PostgreSQL, SQL Server o MongoDB.',
      ),
      StepData(
        '03',
        Icons.settings_suggest_rounded,
        'Crea tu instancia',
        'Define un nombre y genera tus credenciales de acceso.',
      ),
      StepData(
        '04',
        Icons.code_rounded,
        'Conecta tu proyecto',
        'Utiliza las credenciales desde tu lenguaje o cliente favorito.',
      ),
    ];

    return SectionContainer(
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'CÓMO FUNCIONA',
            title: 'De cero a tu primera conexión',
            subtitle:
                'Una experiencia sencilla para que puedas empezar en minutos.',
          ),
          const SizedBox(height: 45),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final itemWidth = width > 900
                  ? (width - 45) / 4
                  : width > 580
                      ? (width - 15) / 2
                      : width;

              return Wrap(
                spacing: 15,
                runSpacing: 30,
                children: steps
                    .map(
                      (step) => StepCard(
                        width: itemWidth,
                        data: step,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.rocket_launch_rounded),
            label: const Text('Crear mi primera instancia'),
            style: FilledButton.styleFrom(
              backgroundColor: RaftDbApp.navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 27,
                vertical: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StepData {
  const StepData(this.number, this.icon, this.title, this.description);

  final String number;
  final IconData icon;
  final String title;
  final String description;
}

class StepCard extends StatelessWidget {
  const StepCard({
    required this.width,
    required this.data,
    super.key,
  });

  final double width;
  final StepData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [RaftDbApp.cyan, RaftDbApp.blue],
                  ),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Icon(data.icon, color: Colors.white, size: 34),
              ),
              Positioned(
                top: -9,
                right: -9,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: RaftDbApp.navy,
                  child: Text(
                    data.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: const Color(0xFFEAF5FF),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth > 900;

          final description = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TU CENTRO DE CONTROL',
                style: TextStyle(
                  color: RaftDbApp.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Administra todo desde un solo lugar',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 18),
              const Text(
                'Consulta el estado de tus instancias, copia credenciales, '
                'reinicia servicios y accede a herramientas de diagnóstico '
                'desde un panel sencillo.',
                style: TextStyle(
                  color: Color(0xFF52647C),
                  fontSize: 17,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 22),
              const DashboardFeature('Estado en tiempo real'),
              const DashboardFeature('Credenciales de conexión'),
              const DashboardFeature('Acciones rápidas'),
            ],
          );

          if (!desktop) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                description,
                const SizedBox(height: 40),
                const DashboardMockup(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 4, child: description),
              const SizedBox(width: 60),
              const Expanded(flex: 6, child: DashboardMockup()),
            ],
          );
        },
      ),
    );
  }
}

class DashboardFeature extends StatelessWidget {
  const DashboardFeature(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: const BoxDecoration(
              color: Color(0xFFD9F6ED),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF13A46E),
              size: 18,
            ),
          ),
          const SizedBox(width: 11),
          Text(
            label,
            style: const TextStyle(
              color: RaftDbApp.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardMockup extends StatelessWidget {
  const DashboardMockup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 380),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD5E2F0)),
        boxShadow: [
          BoxShadow(
            color: RaftDbApp.navy.withOpacity(0.13),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            color: RaftDbApp.navy,
            child: const Row(
              children: [
                CircleAvatar(radius: 5, backgroundColor: Color(0xFFFF6B6B)),
                SizedBox(width: 7),
                CircleAvatar(radius: 5, backgroundColor: Color(0xFFFFC857)),
                SizedBox(width: 7),
                CircleAvatar(radius: 5, backgroundColor: Color(0xFF34C88A)),
                Spacer(),
                Text(
                  'app.raftdb.dev',
                  style: TextStyle(color: Color(0xFFBFCDE0), fontSize: 12),
                ),
                Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    RaftLogo(),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Color(0xFFE5F6FF),
                      child: Icon(
                        Icons.person_rounded,
                        color: RaftDbApp.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Mis bases de datos',
                  style: TextStyle(
                    color: RaftDbApp.navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                const DashboardDbRow(
                  name: 'api-estudiantes',
                  engine: 'PostgreSQL',
                  color: Color(0xFF326FA4),
                ),
                const SizedBox(height: 10),
                const DashboardDbRow(
                  name: 'tienda-demo',
                  engine: 'MongoDB',
                  color: Color(0xFF19A85B),
                ),
                const SizedBox(height: 10),
                const DashboardDbRow(
                  name: 'practica-sql',
                  engine: 'MySQL',
                  color: Color(0xFF0878D1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardDbRow extends StatelessWidget {
  const DashboardDbRow({
    required this.name,
    required this.engine,
    required this.color,
    super.key,
  });

  final String name;
  final String engine;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE4ECF4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(Icons.storage_rounded, color: color, size: 18),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: RaftDbApp.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  engine,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          const Text(
            '● Activa',
            style: TextStyle(
              color: Color(0xFF15965E),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class UseCasesSection extends StatelessWidget {
  const UseCasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const cases = [
      BenefitData(
        Icons.school_rounded,
        'Estudiantes',
        'Practica bases de datos sin instalar servidores ni configurar entornos.',
        Color(0xFF7047E8),
      ),
      BenefitData(
        Icons.code_rounded,
        'Desarrolladores',
        'Crea prototipos, valida integraciones y prueba tus APIs.',
        Color(0xFF0878D1),
      ),
      BenefitData(
        Icons.co_present_rounded,
        'Docentes',
        'Proporciona entornos consistentes para cursos y talleres.',
        Color(0xFF0BB6B2),
      ),
    ];

    return SectionContainer(
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'CASOS DE USO',
            title: 'Diseñado para aprender y experimentar',
            subtitle:
                'Una plataforma accesible para educación, desarrollo y pruebas.',
          ),
          const SizedBox(height: 42),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 750
                  ? (constraints.maxWidth - 36) / 3
                  : constraints.maxWidth;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: cases
                    .map(
                      (item) => UseCaseCard(
                        width: cardWidth,
                        data: item,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class UseCaseCard extends StatelessWidget {
  const UseCaseCard({
    required this.width,
    required this.data,
    super.key,
  });

  final double width;
  final BenefitData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(27),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDFE9F3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 33,
            backgroundColor: data.color.withOpacity(0.12),
            child: Icon(data.icon, color: data.color, size: 31),
          ),
          const SizedBox(height: 18),
          Text(
            data.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 9),
          Text(
            data.description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

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
          const SectionTitle(
            eyebrow: 'PREGUNTAS FRECUENTES',
            title: '¿Tienes alguna duda?',
            subtitle:
                'Estas son algunas de las preguntas más comunes sobre Raft DB.',
          ),
          const SizedBox(height: 35),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              children: questions
                  .map(
                    (question) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFD),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFE1EAF3),
                        ),
                      ),
                      child: ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        iconColor: RaftDbApp.blue,
                        collapsedIconColor: RaftDbApp.navy,
                        title: Text(
                          question[0],
                          style: const TextStyle(
                            color: RaftDbApp.navy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              17,
                              0,
                              45,
                              20,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(question[1]),
                            ),
                          ),
                        ],
                      ),
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

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 90),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 65,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [RaftDbApp.navy, Color(0xFF075DA2)],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.sailing_rounded,
                  color: RaftDbApp.cyan,
                  size: 56,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Lleva tu próximo proyecto a flote',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Crea una base de datos gratuita y empieza a construir en minutos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC7D7EA),
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.rocket_launch_rounded),
                      label: const Text('Comenzar gratis'),
                      style: FilledButton.styleFrom(
                        backgroundColor: RaftDbApp.cyan,
                        foregroundColor: RaftDbApp.navy,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 20,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 20,
                        ),
                      ),
                      child: const Text('Ver documentación'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF041634),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 700;

              final columns = const Wrap(
                spacing: 55,
                runSpacing: 35,
                children: [
                  FooterColumn(
                    title: 'Bases de datos',
                    links: ['MySQL', 'PostgreSQL', 'SQL Server', 'MongoDB'],
                  ),
                  FooterColumn(
                    title: 'Recursos',
                    links: ['Documentación', 'Guías', 'Estado', 'Soporte'],
                  ),
                  FooterColumn(
                    title: 'Legal',
                    links: ['Términos', 'Privacidad', 'Política de datos'],
                  ),
                ],
              );

              return Column(
                children: [
                  if (desktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RaftLogo(light: true),
                              SizedBox(height: 16),
                              Text(
                                'Bases de datos gratuitas para aprender, '
                                'probar y construir.',
                                style: TextStyle(
                                  color: Color(0xFFAFC0D6),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                        Expanded(flex: 2, child: columns),
                      ],
                    )
                  else ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: RaftLogo(light: true),
                    ),
                    const SizedBox(height: 17),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bases de datos gratuitas para aprender, probar y construir.',
                        style: TextStyle(color: Color(0xFFAFC0D6)),
                      ),
                    ),
                    const SizedBox(height: 35),
                    columns,
                  ],
                  const SizedBox(height: 45),
                  Divider(color: Colors.white.withOpacity(0.12)),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          '© 2026 Raft DB. Todos los derechos reservados.',
                          style: TextStyle(
                            color: Color(0xFF8297B1),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.code_rounded,
                        color: RaftDbApp.cyan,
                        size: 19,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Hecho para desarrolladores',
                        style: TextStyle(
                          color: Color(0xFF8297B1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FooterColumn extends StatelessWidget {
  const FooterColumn({
    required this.title,
    required this.links,
    super.key,
  });

  final String title;
  final List<String> links;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 135,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ...links.map(
            (link) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Text(
                link,
                style: const TextStyle(
                  color: Color(0xFF91A5BE),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.child,
    this.background = RaftDbApp.background,
    super.key,
  });

  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 88,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: child,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.light = false,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          eyebrow,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: RaftDbApp.cyan,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 13),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: light ? Colors.white : RaftDbApp.navy,
              ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: light
                  ? const Color(0xFFB7C8DD)
                  : const Color(0xFF607189),
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}