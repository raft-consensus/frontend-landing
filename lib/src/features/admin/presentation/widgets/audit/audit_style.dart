import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/audit_event.dart'; // Domain


class AuditStyle {
  const AuditStyle(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

AuditStyle auditStyle(AuditLevel level) {
  switch (level) {
    case AuditLevel.info:
      return const AuditStyle(
        'Información',
        AppColors.blue,
        Icons.info_outline_rounded,
      );
    case AuditLevel.warning:
      return const AuditStyle(
        'Advertencia',
        AppColors.orange,
        Icons.warning_amber_rounded,
      );
    case AuditLevel.critical:
      return const AuditStyle(
        'Crítico',
        AppColors.red,
        Icons.error_outline_rounded,
      );
  }
}
