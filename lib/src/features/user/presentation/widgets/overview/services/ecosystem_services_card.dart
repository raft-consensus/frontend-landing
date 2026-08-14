// ==========================================
// Qué hace: Contenedor que agrupa las opciones del Ecosistema de Servicios Raft (DNS, IA, n8n).
// Dónde se conecta: Renderizado en el panel central de OverviewPage.
// De dónde trae datos: Recibe callbacks onGoDns, onGoAi y onGoN8n.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/services/ecosystem_service_tile.dart';

/// Tarjeta contenedora de servicios integrados del clúster Raft
class EcosystemServicesCard extends StatelessWidget {
  const EcosystemServicesCard({
    this.onGoDns, // Callback opcional a DNS
    this.onGoAi, // Callback opcional a IA
    this.onGoN8n, // Callback opcional a N8N
    super.key,
  });

  final VoidCallback? onGoDns;
  final VoidCallback? onGoAi;
  final VoidCallback? onGoN8n;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          // 1. Cabecera del ecosistema
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
          const SizedBox(height: 16),

          // 2. Servicio DNS
          EcosystemServiceTile(
            icon: Icons.language_rounded,
            color: const Color(0xFF2C7BC9),
            title: 'Gestión de DNS & Subdominios',
            description: 'Zonas DNS distribuidas y resolutor SSL automático',
            status: 'Activo',
            onTap: onGoDns,
          ),
          const SizedBox(height: 10),

          // 3. Servicio IA
          EcosystemServiceTile(
            icon: Icons.psychology_rounded,
            color: const Color(0xFF2F9E6D),
            title: 'Servicio de IA (API Keys)',
            description: 'Generación y administración de API Keys de Inteligencia Artificial',
            status: 'Disponible',
            onTap: onGoAi,
          ),
          const SizedBox(height: 10),

          // 4. Servicio N8N
          EcosystemServiceTile(
            icon: Icons.bolt_rounded,
            color: const Color(0xFFF28C28),
            title: 'Automatización N8N',
            description: 'Instancia privada y enlace a flujos de trabajo',
            status: 'En ejecución',
            onTap: onGoN8n,
          ),
        ],
      ),
    );
  }
}
