// ==========================================
// Que hace: Pagina de configuracion de cuenta con formularios de edicion de perfil y seguridad sin encabezados redundantes.
// De donde trae datos: Orquesta ProfileInfoCard y SecurityCard en layout responsivo.
// Donde se conecta: Quinta pestana renderizada dentro de DashboardPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile_info_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/security_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';

/// Pagina de gestion de cuenta y seguridad del usuario
class AccountPage extends StatelessWidget {
  const AccountPage({
    required this.onMessage, // Callback para notificaciones
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Layout responsivo directo: Row en escritorio, Column en movil
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 850;

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna Izquierda: Datos del Perfil
                    Expanded(
                      child: ProfileInfoCard(onMessage: onMessage),
                    ),
                    const SizedBox(width: 20),
                    // Columna Derecha: Seguridad y Cambio de Contraseña
                    Expanded(
                      child: SecurityCard(onMessage: onMessage),
                    ),
                  ],
                );
              }

              // Vista vertical para tablets y moviles
              return Column(
                children: [
                  ProfileInfoCard(onMessage: onMessage),
                  const SizedBox(height: 20),
                  SecurityCard(onMessage: onMessage),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
