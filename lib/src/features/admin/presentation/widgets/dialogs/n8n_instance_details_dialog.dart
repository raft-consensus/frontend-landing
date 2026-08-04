import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/n8n_instance.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/colored_icon.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/dialogs/dialog_information.dart'; // Widget


class N8nInstanceDetailsDialog extends StatelessWidget {
  const N8nInstanceDetailsDialog({
    required this.instance,
    super.key,
  });

  final N8nInstance instance;

  @override
  Widget build(BuildContext context) {
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
                  const ColoredIcon(
                    icon: Icons.hub_rounded,
                    color: AppColors.cyan,
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instance.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          instance.host,
                          style: const TextStyle(
                            color: AppColors.cyan,
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
                value: instance.owner,
              ),
              DialogInformation(
                label: 'Workflows configurados',
                value: '${instance.workflows}',
              ),
              DialogInformation(
                label: 'Ejecuciones (30 días)',
                value: '${instance.executions30d}',
              ),
              DialogInformation(
                label: 'Fecha de creación',
                value: instance.createdAt,
              ),
              DialogInformation(
                label: 'Estado',
                value: instance.running ? 'En ejecución' : 'Detenida',
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9FBFA),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: AppColors.cyan,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Las credenciales del webhook y del editor están '
                        'protegidas y no se muestran en el panel '
                        'administrativo.',
                        style: TextStyle(
                          color: Color(0xFF0E6B67),
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
