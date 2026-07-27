import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/raft_logo.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/footer/footer_column.dart';

/// Pie de página (Footer) de la aplicación Raft DB.
/// 
/// ¿Qué hace?: Muestra el logo corporativo en modo claro, las columnas de navegación, el divisor y los derechos reservados.
/// ¿De dónde recibe datos?: Instancia componentes estáticos de navegación.
/// ¿Hacia dónde va / Dónde se conecta?: Se incluye al final de LandingScreen (landing_page.dart).
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

              const columns = Wrap(
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
                        const Expanded(flex: 2, child: columns),
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
                  Divider(color: Colors.white.withValues(alpha: 0.12)),
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
                        color: AppColors.cyan,
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
