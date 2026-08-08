import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Diálogo modal para solicitar el nombre/etiqueta de la nueva API Key de IA.
/// ¿De dónde trae datos?: Formulario con soporte para modo Claro (Raft Day) y Oscuro (Raft Night).
/// ¿Hacia dónde va / Cómo se conecta?: Invocado desde AiServicesPage al presionar "+ Generar API Key".
class CreateAiKeyDialog extends StatefulWidget {
  const CreateAiKeyDialog({super.key});

  @override
  State<CreateAiKeyDialog> createState() => _CreateAiKeyDialogState();
}

class _CreateAiKeyDialogState extends State<CreateAiKeyDialog> {
  final _nameController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Ingresa un nombre o etiqueta para identificar tu API Key.');
      return;
    }
    Navigator.pop(context, {'name': name});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Dialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                    child: Icon(Icons.key_rounded, color: theme.colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Generar API Key de IA',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: titleColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Asigna un nombre descriptivo para identificar el cliente o aplicación que utilizará esta clave.',
                style: TextStyle(fontSize: 12, color: subtitleColor),
              ),
              const SizedBox(height: 20),

              // Campo de Nombre
              TextField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Nombre / Aplicación',
                  hintText: 'ej. App Movil Producción o Bot Backend',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  isDense: true,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(_errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
              ],
              const SizedBox(height: 24),

              // Acciones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, null),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.dividerColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Generar Clave'),
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
