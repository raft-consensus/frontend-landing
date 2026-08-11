import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/plan_details_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile_info_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/security_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';

/// Página de gestión de cuenta, seguridad, perfil y plan del usuario.
/// 
/// ¿Qué hace?: Presenta en orden: 1. Seguridad (Cambio de clave), 2. Perfil de usuario, 3. Estado del plan.
/// ¿De dónde trae?: Widgets modulares de la carpeta account.
/// ¿Hacia dónde va / Cómo se conecta?: Quinta pestaña renderizada dentro de DashboardPage.
class AccountPage extends StatelessWidget {
  const AccountPage({
    required this.onMessage,
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Mi Cuenta y Configuración',
            subtitle: 'Gestiona tu clave de acceso, información personal y límites de tu plan',
          ),
          const SizedBox(height: 24),

          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      // 1. Primero cambiar contraseña
                      SecurityCard(onMessage: onMessage),
                      const SizedBox(height: 20),
                      // 2. Luego editar perfil
                      ProfileInfoCard(onMessage: onMessage),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: PlanDetailsCard(onMessage: onMessage),
                ),
              ],
            )
          else ...[
            SecurityCard(onMessage: onMessage),
            const SizedBox(height: 20),
            ProfileInfoCard(onMessage: onMessage),
            const SizedBox(height: 20),
            PlanDetailsCard(onMessage: onMessage),
          ],
        ],
      ),
    );
  }
}
