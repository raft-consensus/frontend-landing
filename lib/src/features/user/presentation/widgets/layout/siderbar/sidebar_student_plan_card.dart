// ==========================================
// Que hace: Tarjeta interactiva del panel lateral con telemetria en vivo del consumo del Plan Desarrollador (BDs, DNS, IA, n8n).
// De donde trae datos: Escucha reactivamente userDatabasesProvider, userDnsProvider, userAiProvider y userN8nProvider via Riverpod.
// Donde se conecta: Posicionado en la parte inferior de DashboardSidebar.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_dns_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_n8n_provider.dart';

/// Tarjeta de resumen de cuotas del Plan Desarrollador en el Sidebar
class SidebarStudentPlanCard extends ConsumerWidget {
  const SidebarStudentPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 1. Obtencion reactiva de los datos de consumo de cada servicio
    final instances = ref.watch(userDatabasesProvider);
    final dnsRecords = ref.watch(userDnsProvider);
    final aiKeys = ref.watch(userAiProvider);
    final n8nData = ref.watch(userN8nProvider);

    // 2. Calculo de metricas y cuotas maximas reales
    final dbCount = instances.length;
    const dbMax = 12; // 3 instancias x 4 motores

    final dnsCount = dnsRecords.length;
    const dnsMax = 10;

    final aiCount = aiKeys.where((k) => k.isActive).length;
    const aiMax = 10;

    final n8nCount = n8nData?.activeWorkflows ?? 0;
    const n8nMax = 10;

    // 3. Colores adaptativos segun el tema
    final cardBg = isDark
        ? AppColors.nightCard.withValues(alpha: 0.65)
        : const Color(0xFFF1F6FB);
    final borderColor = isDark ? AppColors.nightBorder : const Color(0xFFD6E4F0);
    final primaryTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final secondaryTextColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final primaryColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado: Nombre del Plan + Badge Freemium
          Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                size: 16,
                color: primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Desarrollador',
                style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: isDark ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Freemium',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1. Mini barra: Bases de Datos
          _ServiceQuotaMiniRow(
            icon: Icons.storage_rounded,
            label: 'Bases de datos',
            current: dbCount,
            max: dbMax,
            color: const Color(0xFF0284C7),
            textColor: secondaryTextColor,
          ),
          const SizedBox(height: 8),

          // 2. Mini barra: DNS & SSL
          _ServiceQuotaMiniRow(
            icon: Icons.language_rounded,
            label: 'DNS / SSL',
            current: dnsCount,
            max: dnsMax,
            color: const Color(0xFF10B981),
            textColor: secondaryTextColor,
          ),
          const SizedBox(height: 8),

          // 3. Mini barra: API Keys de IA
          _ServiceQuotaMiniRow(
            icon: Icons.psychology_rounded,
            label: 'API Keys IA',
            current: aiCount,
            max: aiMax,
            color: const Color(0xFFF59E0B),
            textColor: secondaryTextColor,
          ),
          const SizedBox(height: 8),

          // 4. Mini barra: Workflows n8n
          _ServiceQuotaMiniRow(
            icon: Icons.hub_rounded,
            label: 'Workflows n8n',
            current: n8nCount,
            max: n8nMax,
            color: const Color(0xFF8B5CF6),
            textColor: secondaryTextColor,
          ),
        ],
      ),
    );
  }
}

/// Sub-widget: Fila con etiqueta, valor y barra de progreso grafica
class _ServiceQuotaMiniRow extends StatelessWidget {
  const _ServiceQuotaMiniRow({
    required this.icon,
    required this.label,
    required this.current,
    required this.max,
    required this.color,
    required this.textColor,
  });

  final IconData icon; // Icono del servicio
  final String label; // Nombre breve
  final int current; // Valor consumido actual
  final int max; // Valor maximo permitido
  final Color color; // Color tematico de la barra
  final Color? textColor; // Color del texto

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressValue = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    final trackBgColor = isDark ? const Color(0xFF1E2D3D) : const Color(0xFFE2E8F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$current / $max',
              style: TextStyle(
                color: textColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: trackBgColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
