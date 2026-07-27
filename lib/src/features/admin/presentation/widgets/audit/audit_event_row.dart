import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/audit_event.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/status_chip.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/audit/audit_style.dart'; // Widget

class AuditEventRow extends StatelessWidget {
  const AuditEventRow({
    required this.event,
    super.key,
  });

  final AuditEvent event;

  @override
  Widget build(BuildContext context) {
    final style = auditStyle(event.level);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;

          final main = Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: style.color.withOpacity(0.10),
                child: Icon(
                  style.icon,
                  color: style.color,
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.action,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${event.actor} · ${event.resource}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final details = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusChip(
                label: style.label,
                color: style.color,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    event.date,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.ip,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          );

          if (compact) {
            return Column(
              children: [
                main,
                const SizedBox(height: 13),
                Align(
                  alignment: Alignment.centerRight,
                  child: details,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: main),
              details,
            ],
          );
        },
      ),
    );
  }
}
