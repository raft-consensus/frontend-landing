import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/plan/plan_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/plan/plan_quota_row.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/plan/plan_upgrade_button.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart';

/// Tarjeta lateral informativa con el estado del plan actual y cuotas de uso.
/// 
/// ¿Qué hace?: Muestra el tipo de plan activo y sus métricas principales totalmente adaptadas al tema dinámico.
/// ¿De dónde recibe datos?: Callback [onMessage] para notificaciones.
/// ¿Hacia dónde se conecta?: Columna lateral de AccountPage.
class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({
    required this.onMessage,
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlanHeader(),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),

          const PlanQuotaRow(label: 'Instancias de BD', value: '3 de 5 creadas'),
          const SizedBox(height: 10),
          const PlanQuotaRow(label: 'Almacenamiento total', value: '326 MB / 512 MB'),
          const SizedBox(height: 10),
          const PlanQuotaRow(label: 'Soporte', value: 'Comunidad & Guías'),
          const SizedBox(height: 22),

          PlanUpgradeButton(
            onPressed: () => onMessage('Solicitud de upgrade enviada.'),
          ),
        ],
      ),
    );
  }
}
