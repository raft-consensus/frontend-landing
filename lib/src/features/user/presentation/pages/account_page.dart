import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/plan_details_card.dart'; // Account
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile_info_card.dart'; // Account
import 'package:frontend_landing/src/features/user/presentation/widgets/account/security_card.dart'; // Account
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart'; // Common

/// ¿Qué hace?: Página web de gestión de cuenta, perfil, seguridad y plan del usuario.
/// ¿De dónde trae?: Trae widgets de common y las 3 tarjetas de account (ProfileInfoCard, SecurityCard, PlanDetailsCard).
/// ¿Hacia dónde va / Cómo se conecta?: Es la quinta pestaña renderizada dentro de DashboardPage.
class AccountPage extends StatelessWidget {
  const AccountPage({
    required this.onMessage, // Callback para notificaciones snackbar
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
          // Encabezado de sección
          const SectionHeader(
            title: 'Mi Cuenta y Configuración',
            subtitle: 'Gestiona tu información personal, clave de acceso y límites de tu plan',
          ),
          const SizedBox(height: 24),

          // Disposición responsiva de tarjetas (2 columnas en Desktop o 1 en Móvil)
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      ProfileInfoCard(onMessage: onMessage),
                      const SizedBox(height: 20),
                      SecurityCard(onMessage: onMessage),
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
            ProfileInfoCard(onMessage: onMessage),
            const SizedBox(height: 20),
            SecurityCard(onMessage: onMessage),
            const SizedBox(height: 20),
            PlanDetailsCard(onMessage: onMessage),
          ],
        ],
      ),
    );
  }
}
