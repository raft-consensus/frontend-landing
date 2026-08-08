import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/service_item_tile.dart';

/// ¿Qué hace?: Contenedor principal que agrupa las tarjetas de los 3 servicios integrados del clúster Raft.
/// ¿De dónde trae datos?: Ingesta callbacks de navegación y renderiza los ServiceItemTile desacoplados.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza en el panel central de OverviewPage.
class EcosystemServicesCard extends StatelessWidget {
  const EcosystemServicesCard({
    this.onGoDns, // Callback opcional para navegar a la pestaña de Dominio & SSL (DNS)
    this.onGoAi,  // Callback opcional para navegar al servicio de IA Keys
    this.onGoN8n, // Callback opcional para navegar al servicio de N8N
    super.key,
  });

  final VoidCallback? onGoDns;
  final VoidCallback? onGoAi;
  final VoidCallback? onGoN8n;

  @override
  Widget build(BuildContext context) {
    // 1. Detecta la luminosidad del tema (Raft Day vs Raft Night)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. Colores dinámicos del contenedor
    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-widget 1: Cabecera del panel de servicios
          _EcosystemHeader(
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          // Sub-widget 2: Item 1 - Gestión de DNS & Subdominios
          ServiceItemTile(
            icon: Icons.language_rounded,
            color: const Color(0xFF2C7BC9),
            title: 'Gestión de DNS & Subdominios',
            description: 'Zonas DNS distribuidas y resolutor SSL automático',
            status: 'Activo',
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            isDark: isDark,
            onTap: onGoDns,
          ),
          const SizedBox(height: 10),

          // Sub-widget 3: Item 2 - Servicio de IA (API Keys)
          ServiceItemTile(
            icon: Icons.psychology_rounded,
            color: const Color(0xFF2F9E6D),
            title: 'Servicio de IA (API Keys)',
            description: 'Generación y administración de API Keys de Inteligencia Artificial',
            status: 'Disponible',
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            isDark: isDark,
            onTap: onGoAi,
          ),
          const SizedBox(height: 10),

          // Sub-widget 4: Item 3 - Automatización N8N
          ServiceItemTile(
            icon: Icons.bolt_rounded,
            color: const Color(0xFFF28C28),
            title: 'Automatización N8N',
            description: 'Instancia privada y enlace a flujos de trabajo',
            status: 'En ejecución',
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            isDark: isDark,
            onTap: onGoN8n,
          ),
        ],
      ),
    );
  }
}

/// Sub-widget privado: Cabecera con título del panel e icono de hub
class _EcosystemHeader extends StatelessWidget {
  const _EcosystemHeader({
    required this.titleColor,
    required this.subtitleColor,
    required this.isDark,
  });

  final Color titleColor;
  final Color subtitleColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Ecosistema de Servicios Raft',
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.hub_rounded,
              color: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Servicios distribuidos y herramientas avanzadas integradas en tu clúster',
          style: TextStyle(color: subtitleColor, fontSize: 12),
        ),
      ],
    );
  }
}
