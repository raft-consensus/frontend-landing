// ==========================================
// ¿Qué hace?: Renderiza una columna de enlaces con título en el pie de página.
// ¿De dónde trae datos?: Ingesta un título y una lista de enlaces string.
// ¿Hacia dónde va / Cómo se conecta?: Utilizado dentro de FooterSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.nightTextPrimary : Colors.white;
    final linkColor = isDark ? AppColors.nightTextSecondary : const Color(0xFFAFC0D6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {}, // Callback para futura navegación de enlaces
              child: Text(
                link,
                style: TextStyle(
                  color: linkColor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
