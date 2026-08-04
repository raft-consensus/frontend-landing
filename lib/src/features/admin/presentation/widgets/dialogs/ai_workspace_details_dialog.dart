import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/ai_workspace.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/colored_icon.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/dialogs/dialog_information.dart'; // Widget


class AiWorkspaceDetailsDialog extends StatelessWidget {
  const AiWorkspaceDetailsDialog({
    required this.workspace,
    super.key,
  });

  final AiWorkspace workspace;

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
                    icon: Icons.smart_toy_rounded,
                    color: AppColors.purple,
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workspace.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          workspace.provider,
                          style: const TextStyle(
                            color: AppColors.purple,
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
                value: workspace.owner,
              ),
              DialogInformation(
                label: 'Modelo',
                value: workspace.model,
              ),
              DialogInformation(
                label: 'Consumo de peticiones',
                value:
                    '${workspace.requestsUsed} / ${workspace.requestsLimit}',
              ),
              DialogInformation(
                label: 'Fecha de creación',
                value: workspace.createdAt,
              ),
              DialogInformation(
                label: 'Estado',
                value: workspace.active ? 'Activo' : 'Suspendido',
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEFF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.key_rounded,
                      color: AppColors.purple,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'La API key del workspace está protegida y no se '
                        'muestra en el panel administrativo.',
                        style: TextStyle(
                          color: Color(0xFF4B3A8E),
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
