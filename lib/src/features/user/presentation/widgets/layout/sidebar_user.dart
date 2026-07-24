import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Trae AppColors de core

/// ¿Qué hace?: Tarjeta gráfica inferior del Sidebar con avatar, nombre, email del usuario y botón de salida.
/// ¿De dónde trae?: Consume AppColors de core/theme/app_colors.dart.
/// ¿Hacia dónde va / Cómo se conecta?: Se coloca en la parte inferior de DashboardSidebar.
class SidebarUser extends StatelessWidget {
  const SidebarUser({super.key});

  @override
  Widget build(BuildContext context) {
    // Tarjeta con fondo azul grisáceo tenue
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar circular con las iniciales "RU" (Raft User)
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.navy,
            child: Text(
              'RU',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Nombre y correo del usuario
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuario Raft',
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'user@raftdb.dev',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Botón gráfico de cerrar sesión (Icono de salida)
          IconButton(
            onPressed: () {
              // Notificación gráfica de salida
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sesión cerrada')),
              );
            },
            icon: const Icon(
              Icons.logout_rounded,
              size: 18,
              color: AppColors.muted,
            ),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
    );
  }
}
