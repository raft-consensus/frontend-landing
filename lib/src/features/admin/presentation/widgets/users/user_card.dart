import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/platform_user.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/status_chip.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/engine_style.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/users/user_information.dart'; // Widget


class UserCard extends StatelessWidget {
  const UserCard({
    required this.width,
    required this.user,
    required this.onDetails,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final double width;
  final PlatformUser user;
  final VoidCallback onDetails;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: user.suspended
                    ? AppColors.red.withOpacity(0.10)
                    : AppColors.blue.withOpacity(0.11),
                child: Text(
                  initials(user.name),
                  style: TextStyle(
                    color:
                        user.suspended ? AppColors.red : AppColors.blue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user.email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: user.suspended ? 'Suspendido' : 'Activo',
                color:
                    user.suspended ? AppColors.red : AppColors.green,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'details') onDetails();
                  if (value == 'toggle') onToggle();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'details',
                    child: Text('Ver detalles'),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(
                      user.suspended
                          ? 'Reactivar cuenta'
                          : 'Suspender cuenta',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Eliminar usuario',
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 19),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                UserInformation(
                  label: 'Instancias',
                  value: '${user.instances}',
                ),
                const VerticalDivider(width: 28),
                UserInformation(
                  label: 'Registro',
                  value: user.createdAt,
                ),
                const VerticalDivider(width: 28),
                UserInformation(
                  label: 'Último acceso',
                  value: user.lastAccess,
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Ver cuenta'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onToggle,
                style: OutlinedButton.styleFrom(
                  foregroundColor: user.suspended
                      ? AppColors.green
                      : AppColors.orange,
                ),
                child: Text(
                  user.suspended ? 'Reactivar' : 'Suspender',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
