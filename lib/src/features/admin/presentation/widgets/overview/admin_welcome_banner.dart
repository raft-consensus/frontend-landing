import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core


class AdminWelcomeBanner extends StatelessWidget {
  const AdminWelcomeBanner({
    required this.maintenanceMode,
    required this.onMessage,
    super.key,
  });

  final bool maintenanceMode;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(27),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.navy,
            Color(0xFF0A457B),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 680;

          final information = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Centro de control de Raft DB',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Supervisa usuarios, instancias e infraestructura '
                'desde una única plataforma.',
                style: TextStyle(
                  color: Color(0xFFB7C9DD),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 19),
              FilledButton.icon(
                onPressed: () => onMessage(
                  'El reporte general está siendo generado.',
                  success: true,
                ),
                icon: const Icon(Icons.download_rounded),
                label: const Text('Generar reporte'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  foregroundColor: AppColors.deepNavy,
                ),
              ),
            ],
          );

          final status = Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  maintenanceMode
                      ? Icons.construction_rounded
                      : Icons.check_circle_rounded,
                  color: maintenanceMode
                      ? AppColors.orange
                      : AppColors.cyan,
                  size: 31,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maintenanceMode
                          ? 'Modo mantenimiento'
                          : 'Plataforma operativa',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      maintenanceMode
                          ? 'Acceso restringido'
                          : 'Sin incidentes activos',
                      style: TextStyle(
                        color: maintenanceMode
                            ? AppColors.orange
                            : AppColors.cyan,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                information,
                const SizedBox(height: 22),
                status,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: information),
              status,
            ],
          );
        },
      ),
    );
  }
}
