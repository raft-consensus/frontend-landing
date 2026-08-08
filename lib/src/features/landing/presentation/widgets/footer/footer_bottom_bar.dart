// ==========================================
// ¿Qué hace?: Renderiza el divisor inferior, los derechos reservados de Raft Cloud y el sello de comunidad.
// ¿De dónde trae datos?: Ingesta subtitleColor para adaptarse al tema.
// ¿Hacia dónde va / Cómo se conecta?: Invocado al final de FooterSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

class FooterBottomBar extends StatelessWidget {
  const FooterBottomBar({
    required this.subtitleColor,
    super.key,
  });

  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Colors.white.withValues(alpha: 0.12)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(
                '© 2026 Raft Cloud. Todos los derechos reservados.',
                style: TextStyle(color: subtitleColor, fontSize: 12),
              ),
            ),
            const Icon(Icons.code_rounded, color: AppColors.cyan, size: 19),
            const SizedBox(width: 6),
            Text(
              'Hecho para desarrolladores',
              style: TextStyle(color: subtitleColor, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
