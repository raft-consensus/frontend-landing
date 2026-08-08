// ==========================================
// ¿Qué hace?: Pie de página (Footer) orquestador desacoplado en componentes independientes.
// ¿De dónde trae datos?: Instancia RaftLogo, FooterColumn y FooterBottomBar.
// ¿Hacia dónde va / Cómo se conecta?: Se incluye al final de LandingPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/raft_logo.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/footer/footer_bottom_bar.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/footer/footer_column.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final footerBg = isDark ? AppColors.nightBackground : const Color(0xFF041634);
    final subtitleColor = isDark ? AppColors.nightTextSecondary : const Color(0xFFAFC0D6);

    const columns = Wrap(
      spacing: 55,
      runSpacing: 35,
      children: [
        FooterColumn(
          title: 'Servicios',
          links: ['Bases de datos', 'DNS & Red', 'API Keys IA', 'n8n Workflows'],
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

    return Container(
      width: double.infinity,
      color: footerBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 700;

              return Column(
                children: [
                  if (desktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const RaftLogo(light: true),
                              const SizedBox(height: 16),
                              Text(
                                'Servicios cloud gratuitos para aprender, automatizar y construir.',
                                style: TextStyle(color: subtitleColor, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                        const Expanded(flex: 2, child: columns),
                      ],
                    )
                  else ...[
                    const Align(alignment: Alignment.centerLeft, child: RaftLogo(light: true)),
                    const SizedBox(height: 17),
                    Text('Servicios cloud gratuitos para aprender, automatizar y construir.', style: TextStyle(color: subtitleColor)),
                    const SizedBox(height: 35),
                    columns,
                  ],
                  const SizedBox(height: 45),
                  FooterBottomBar(subtitleColor: subtitleColor),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
