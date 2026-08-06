import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Modal del Ecosistema Raft Hub que presenta los servicios activos y futuros (Bases de datos, IA, DNS, N8N).
/// ¿De dónde trae datos?: Recibe el callback onCreateDatabase para aprovisionar una nueva BD al hacer clic en el servicio activo.
/// ¿Dónde se conecta?: Invocado al hacer clic en el botón principal "Ecosistema Raft" en DashboardTopbar.
class ServicesHubDialog extends StatelessWidget {
  const ServicesHubDialog({
    required this.onCreateDatabase,
    super.key,
  });

  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Sub-widget de encabezado
              const _HubHeader(),
              const SizedBox(height: 20),

              // 2. Lista modular de servicios accionables del ecosistema
              _ServiceTile(
                title: 'Bases de Datos Distribuidas',
                subtitle: 'Crear e instanciar SQL Server, PostgreSQL, MySQL o MongoDB',
                icon: Icons.dns_rounded,
                color: AppColors.blue,
                status: 'Activo',
                isActive: true,
                onTap: () {
                  Navigator.pop(context); // Cierra el modal del Hub
                  onCreateDatabase();      // Desencadena el modal de creación de BD
                },
              ),
              const SizedBox(height: 10),
              _ServiceTile(
                title: 'Raft AI Assistant',
                subtitle: 'Consultas en lenguaje natural NL2SQL y optimizador',
                icon: Icons.auto_awesome_rounded,
                color: AppColors.purple,
                status: 'Próximamente',
                isActive: false,
                onTap: () {
                  _showComingSoonMessage(context, 'Raft AI Assistant');
                },
              ),
              const SizedBox(height: 10),
              _ServiceTile(
                title: 'Gestor DNS & Red',
                subtitle: 'Administración de dominios, subdominios y resolución',
                icon: Icons.language_rounded,
                color: AppColors.cyan,
                status: 'Próximamente',
                isActive: false,
                onTap: () {
                  _showComingSoonMessage(context, 'Gestor DNS & Red');
                },
              ),
              const SizedBox(height: 10),
              _ServiceTile(
                title: 'Automatización N8N Workflows',
                subtitle: 'Orquestación de flujos de trabajo e integraciones Webhook',
                icon: Icons.hub_rounded,
                color: AppColors.green,
                status: 'Próximamente',
                isActive: false,
                onTap: () {
                  _showComingSoonMessage(context, 'Automatización N8N');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonMessage(BuildContext context, String serviceName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('El servicio $serviceName estará disponible próximamente.'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Sub-widget extraído 1: Encabezado del modal con título e icono de cerrar
class _HubHeader extends StatelessWidget {
  const _HubHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFE0EEFC),
          child: Icon(Icons.apps_rounded, color: AppColors.blue),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ecosistema de Servicios Raft',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Selecciona un servicio activo para gestionar o crear recursos.',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

/// Sub-widget extraído 2: Tarjeta individual de servicio accionable del Hub
class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.status,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String status;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? color.withValues(alpha: 0.3) : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              _ServiceAvatar(icon: icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(status: status, isActive: isActive),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (isActive)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.blue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sub-widget extraído 3: Icono circular avatar del servicio
class _ServiceAvatar extends StatelessWidget {
  const _ServiceAvatar({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

/// Sub-widget extraído 4: Insignia de estado (Activo / Próximamente)
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
    required this.isActive,
  });

  final String status;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? AppColors.green : AppColors.muted,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
