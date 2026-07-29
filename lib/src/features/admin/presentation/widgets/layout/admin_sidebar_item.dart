import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/sidebar_data.dart'; // Domain


class AdminSidebarItem extends StatelessWidget {
  const AdminSidebarItem({
    required this.data,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final SidebarData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected
            ? AppColors.blue.withValues(alpha: 0.19)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: selected
                  ? Border.all(
                      color: AppColors.blue.withValues(alpha: 0.22),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  data.icon,
                  size: 21,
                  color: selected
                      ? AppColors.cyan
                      : const Color(0xFF8499B4),
                ),
                const SizedBox(width: 13),
                Text(
                  data.label,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xFF98AAC1),
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                if (selected) ...[
                  const Spacer(),
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: AppColors.cyan,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
