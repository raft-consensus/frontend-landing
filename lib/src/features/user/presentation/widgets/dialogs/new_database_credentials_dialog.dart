// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/dialogs/new_database_credentials_dialog.dart
// Qué hace: Muestra las credenciales de una instancia recién creada, incluida la contraseña
// en texto plano que el backend solo entrega en la respuesta de POST /api/me/databases.
// Dónde se conecta: Se abre desde DashboardPage justo después de un createDatabase() exitoso.
// De dónde recibe datos: Recibe un ProvisioningResultModel ya resuelto, sin volver a llamar a la API.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/data/models/provisioning_result_model.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_banner.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/credential_item.dart';

/// Modal que se muestra UNA sola vez, inmediatamente después de crear una instancia.
/// La contraseña en texto plano no se puede volver a recuperar tras cerrarlo (solo el
/// "reveal" cifrado vía CredentialsDialog, que exige otra llamada autenticada al backend).
class NewDatabaseCredentialsDialog extends StatelessWidget {
  const NewDatabaseCredentialsDialog({
    required this.provisioning,
    required this.onMessage,
    super.key,
  });

  final ProvisioningResultModel provisioning;
  final void Function(String, {bool success}) onMessage;

  void _copy(BuildContext context, String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    onMessage('$label copiado.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    final connectionUri =
        '${provisioning.engine.toLowerCase()}://${provisioning.databaseUser}:'
        '${provisioning.password}@${provisioning.host}:${provisioning.port}/'
        '${provisioning.databaseName}';

    return PopScope(
      canPop: false, // Fuerza al usuario a usar el botón "Ya la guardé" antes de cerrar
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE3F0FC),
                      child: Icon(Icons.check_circle_rounded, color: AppColors.blue),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instancia creada',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Esta es la única vez que verás la contraseña completa.',
                            style: TextStyle(color: AppColors.muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                CredentialItem(
                  label: 'Host',
                  value: provisioning.host,
                  onCopy: () => _copy(context, 'Host', provisioning.host),
                ),
                CredentialItem(
                  label: 'Puerto',
                  value: '${provisioning.port}',
                  onCopy: () => _copy(context, 'Puerto', '${provisioning.port}'),
                ),
                CredentialItem(
                  label: 'Base de datos',
                  value: provisioning.databaseName,
                  onCopy: () => _copy(context, 'Base de datos', provisioning.databaseName),
                ),
                CredentialItem(
                  label: 'Usuario',
                  value: provisioning.databaseUser,
                  onCopy: () => _copy(context, 'Usuario', provisioning.databaseUser),
                ),
                CredentialItem(
                  label: 'Contraseña',
                  value: provisioning.password,
                  onCopy: () => _copy(context, 'Contraseña', provisioning.password),
                ),

                const SizedBox(height: 14),
                const InfoBanner(
                  message:
                      'Guarda esta contraseña ahora. Después de cerrar este cuadro no volverá '
                      'a mostrarse en texto plano.',
                  icon: Icons.warning_amber_rounded,
                  backgroundColor: Color(0xFFFFF8E9),
                  borderColor: Color(0xFFFFE5AF),
                  iconColor: Color(0xFFD98A00),
                  textColor: Color(0xFF76561D),
                ),
                const SizedBox(height: 20),

                _buildUriSection(context, connectionUri),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Ya la guardé'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUriSection(BuildContext context, String uri) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cadena de conexión (URI):',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  uri,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF38BDF8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Copiar URI',
                onPressed: () => _copy(context, 'Cadena de conexión', uri),
                icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
