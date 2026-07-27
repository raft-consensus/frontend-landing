import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/managed_database.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/colored_icon.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/engine_style.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/dialogs/dialog_information.dart'; // Widget


class DatabaseDetailsDialog extends StatelessWidget {
  const DatabaseDetailsDialog({
    required this.database,
    super.key,
  });

  final ManagedDatabase database;

  @override
  Widget build(BuildContext context) {
    final style = engineStyle(database.engine);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ColoredIcon(icon: style.icon, color: style.color),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          database.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          database.engine,
                          style: TextStyle(
                            color: style.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
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
              const SizedBox(height: 24),
              DialogInformation(
                label: 'Propietario',
                value: database.owner,
              ),
              DialogInformation(
                label: 'Host',
                value: database.host,
              ),
              DialogInformation(
                label: 'Almacenamiento',
                value: '${database.storageMb.toStringAsFixed(0)} MB',
              ),
              DialogInformation(
                label: 'Fecha de creación',
                value: database.createdAt,
              ),
              DialogInformation(
                label: 'Estado',
                value: database.running ? 'En ejecución' : 'Detenida',
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: AppColors.orange,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Las credenciales completas están protegidas y '
                        'no se muestran en el panel administrativo.',
                        style: TextStyle(
                          color: Color(0xFF76561F),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
