// ==========================================
// Que hace: Tarjeta ensambladora que combina DocCardHeader, DocCodeSnippetBox y DocExpandToggleButton.
// De donde trae datos: Recibe titulo, descripcion, snippet, icono, badge y notificador.
// Donde se conecta: Consumido por las cuadriculas de cada servicio.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_card_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_code_snippet_box.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_expand_toggle_button.dart';

/// Tarjeta documental modularizada con maxima atomicidad
class DocExpandableCard extends StatefulWidget {
  const DocExpandableCard({
    required this.title, // Titulo de la guia
    required this.description, // Descripcion
    required this.snippet, // Codigo de ejemplo
    required this.icon, // Icono
    required this.badgeText, // Badge
    required this.onMessage, // Callback notificacion
    this.badgeColor, // Color opcional
    this.estimatedTime, // Tiempo estimado
    super.key,
  });

  final String title;
  final String description;
  final String snippet;
  final IconData icon;
  final String badgeText;
  final void Function(String message, {bool success}) onMessage;
  final Color? badgeColor;
  final String? estimatedTime;

  @override
  State<DocExpandableCard> createState() => _DocExpandableCardState();
}

class _DocExpandableCardState extends State<DocExpandableCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = widget.badgeColor ?? (isDark ? AppColors.nightPrimary : AppColors.dayPrimary);

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cabecera modular
          DocCardHeader(
            title: widget.title,
            icon: widget.icon,
            badgeText: widget.badgeText,
            color: color,
            estimatedTime: widget.estimatedTime,
          ),
          const SizedBox(height: 12),

          // 2. Descripcion
          Text(
            widget.description,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // 3. Consola de codigo modular
          if (_expanded) ...[
            DocCodeSnippetBox(
              snippet: widget.snippet,
              onMessage: widget.onMessage,
            ),
            const SizedBox(height: 10),
          ],

          // 4. Boton toggle modular
          DocExpandToggleButton(
            isExpanded: _expanded,
            onToggle: () => setState(() => _expanded = !_expanded),
            color: color,
          ),
        ],
      ),
    );
  }
}
