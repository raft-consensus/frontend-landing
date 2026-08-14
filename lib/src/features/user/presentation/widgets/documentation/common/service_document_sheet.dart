// ==========================================
// Que hace: Hoja informativa en formato de documento plano con descripcion, limites reales y recomendaciones tecnicas.
// De donde trae datos: Recibe campos opcionales (descripcion, capacidades, limites y recomendaciones).
// Donde se conecta: Consumido al final de cada seccion de servicio (Bases de datos, DNS, IA, n8n).
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart';

/// Hoja documental plana y minimalista sin adornos excesivos
class ServiceDocumentSheet extends StatelessWidget {
  const ServiceDocumentSheet({
    this.title = 'Especificaciones y Límites del Servicio', // Titulo del documento
    this.description, // Parrafo explicativo general
    this.offerings, // Puntos clave de lo que ofrece
    this.limits, // Limites reales de uso de la cuenta
    this.recommendations, // Recomendaciones tecnicas y buenas practicas
    super.key,
  });

  final String title; // Titulo principal
  final String? description; // Descripcion breve
  final List<String>? offerings; // Lista de caracteristicas
  final List<String>? limits; // Lista de limites de cuota
  final List<String>? recommendations; // Lista de consejos tecnicos

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    return DashboardCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cabecera del documento
          Row(
            children: [
              Icon(
                Icons.article_outlined,
                size: 20,
                color: primaryColor,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: theme.dividerColor, height: 1),
          const SizedBox(height: 16),

          // 2. Descripcion general
          if (description != null) ...[
            Text(
              description!,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 3. Capacidades y Caracteristicas
          if (offerings != null && offerings!.isNotEmpty) ...[
            _DocSectionTitle(title: 'Capacidades Incluidas', color: primaryColor),
            const SizedBox(height: 8),
            ...offerings!.map((item) => _DocBulletItem(text: item)),
            const SizedBox(height: 16),
          ],

          // 4. Limites Reales de la Cuenta
          if (limits != null && limits!.isNotEmpty) ...[
            _DocSectionTitle(title: 'Límites de Uso', color: const Color(0xFFF59E0B)),
            const SizedBox(height: 8),
            ...limits!.map((item) => _DocBulletItem(text: item)),
            const SizedBox(height: 16),
          ],

          // 5. Recomendaciones de uso
          if (recommendations != null && recommendations!.isNotEmpty) ...[
            _DocSectionTitle(title: 'Recomendaciones Técnicas', color: const Color(0xFF10B981)),
            const SizedBox(height: 8),
            ...recommendations!.map((item) => _DocBulletItem(text: item)),
          ],
        ],
      ),
    );
  }
}

/// Sub-widget: Titulo de cada seccion del documento
class _DocSectionTitle extends StatelessWidget {
  const _DocSectionTitle({
    required this.title,
    required this.color,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Sub-widget: Item de lista con punto tipo documento
class _DocBulletItem extends StatelessWidget {
  const _DocBulletItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
