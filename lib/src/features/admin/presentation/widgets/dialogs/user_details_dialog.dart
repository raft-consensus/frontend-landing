import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/platform_user.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/engine_style.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/dialogs/dialog_information.dart'; // Widget


class UserDetailsDialog extends StatelessWidget {
  const UserDetailsDialog({
    required this.user,
    super.key,
  });

  final PlatformUser user;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.blue.withOpacity(0.10),
                    child: Text(
                      initials(user.name),
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              DialogInformation(
                label: 'Estado',
                value: user.suspended ? 'Suspendido' : 'Activo',
              ),
              DialogInformation(
                label: 'Fecha de registro',
                value: user.createdAt,
              ),
              DialogInformation(
                label: 'Último acceso',
                value: user.lastAccess,
              ),
              DialogInformation(
                label: 'Instancias',
                value: '${user.instances}',
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
