import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/raft_logo.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/dashboard/dashboard_db_row.dart';

/// Componente visual que simula una ventana de navegador web mostrando el Dashboard de Raft DB.
/// 
/// ¿Qué hace?: Dibuja los botones del navegador, la barra de dirección URL, el logo, avatar y filas de BDs activas.
/// ¿De dónde recibe datos?: Renderiza componentes estáticos de demostración.
/// ¿Hacia dónde va / Dónde se conecta?: Renderizado en el lado derecho o inferior de DashboardSection.
class DashboardMockup extends StatelessWidget {
  const DashboardMockup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 380),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD5E2F0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.13),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Barra superior del navegador web
          Container(
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            color: AppColors.navy,
            child: const Row(
              children: [
                CircleAvatar(radius: 5, backgroundColor: Color(0xFFFF6B6B)),
                SizedBox(width: 7),
                CircleAvatar(radius: 5, backgroundColor: Color(0xFFFFC857)),
                SizedBox(width: 7),
                CircleAvatar(radius: 5, backgroundColor: Color(0xFF34C88A)),
                Spacer(),
                Text(
                  'app.raftdb.dev',
                  style: TextStyle(color: Color(0xFFBFCDE0), fontSize: 12),
                ),
                Spacer(),
              ],
            ),
          ),
          
          // Cuerpo principal simulado
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    RaftLogo(),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Color(0xFFE5F6FF),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Mis bases de datos',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                const DashboardDbRow(
                  name: 'api-estudiantes',
                  engine: 'PostgreSQL',
                  color: Color(0xFF326FA4),
                ),
                const SizedBox(height: 10),
                const DashboardDbRow(
                  name: 'tienda-demo',
                  engine: 'MongoDB',
                  color: Color(0xFF19A85B),
                ),
                const SizedBox(height: 10),
                const DashboardDbRow(
                  name: 'practica-sql',
                  engine: 'MySQL',
                  color: Color(0xFF0878D1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
