import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core


class EngineStyle {
  const EngineStyle(this.icon, this.color);

  final IconData icon;
  final Color color;
}

EngineStyle engineStyle(String engine) {
  switch (engine) {
    case 'PostgreSQL':
      return const EngineStyle(
        Icons.storage_rounded,
        Color(0xFF3977A8),
      );
    case 'MySQL':
      return const EngineStyle(
        Icons.dns_rounded,
        AppColors.blue,
      );
    case 'MongoDB':
      return const EngineStyle(
        Icons.eco_rounded,
        AppColors.green,
      );
    case 'SQL Server':
      return const EngineStyle(
        Icons.table_chart_rounded,
        AppColors.red,
      );
    default:
      return const EngineStyle(
        Icons.storage_rounded,
        AppColors.muted,
      );
  }
}

String initials(String name) {
  final parts = name
      .trim()
      .split(' ')
      .where((part) => part.isNotEmpty)
      .toList();

  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();

  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
