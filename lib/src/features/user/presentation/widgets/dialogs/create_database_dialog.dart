import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_banner.dart'; // Common

/// ¿Qué hace?: Modal de confirmación para aprovisionar una nueva instancia MySQL propia.
/// ¿De dónde trae?: Trae AppColors (core) e InfoBanner (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se abre desde DashboardTopbar/WelcomeBanner mediante showDialog().
///
/// Nota: el backend (POST /api/me/databases) solo aprovisiona MySQL por ahora y genera el
/// nombre, usuario y contraseña en el servidor — no hay campo de "nombre de instancia" ni
/// selector de motor porque el backend no los acepta. Cuando exista soporte para otros
/// motores (PostgreSQL, SQL Server, MongoDB) este diálogo puede recuperar el selector.
class CreateDatabaseDialog extends StatefulWidget {
  const CreateDatabaseDialog({super.key});

  @override
  State<CreateDatabaseDialog> createState() => _CreateDatabaseDialogState();
}

class _CreateDatabaseDialogState extends State<CreateDatabaseDialog> {
  bool _creating = false;

  void _confirm() {
    setState(() => _creating = true);
    // Cierra el modal indicando que el usuario confirmó la creación.
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabecera con icono "+" y botón de cerrar "X"
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE0EEFC),
                    child: Icon(Icons.add_rounded, color: AppColors.blue),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Crear nueva instancia MySQL',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'El nombre, usuario y contraseña se generan automáticamente.',
                          style: TextStyle(color: AppColors.muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _creating ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              const InfoBanner(
                message:
                    'La instancia gratuita incluye 512 MB de almacenamiento y acceso remoto. '
                    'Al confirmar verás la contraseña una única vez: guárdala en un lugar seguro.',
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.blue,
              ),
              const SizedBox(height: 25),

              // Botones de acción inferiores
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _creating ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _creating ? null : _confirm,
                    icon: _creating
                        ? const SizedBox(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.rocket_launch_rounded),
                    label: Text(_creating ? 'Creando...' : 'Crear instancia'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
