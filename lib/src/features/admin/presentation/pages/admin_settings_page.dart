import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_scroll_view.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/section_title.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/settings/settings_header.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/settings/limit_slider.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/settings/setting_switch.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/settings/danger_action.dart'; // Widget

/// ¿Qué hace?: Vista 5: Configuración global de la plataforma (límites del plan, accesos, mantenimiento y zona de peligro).
/// ¿De dónde trae?: Trae componentes common (scroll, título, tarjeta) y los widgets propios de configuración.
/// ¿Hacia dónde va / Cómo se conecta?: Es renderizada por AdminDashboardPage cuando el índice seleccionado es 5.
class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({
    required this.maintenanceMode,
    required this.onMaintenanceChanged,
    required this.onMessage,
    super.key,
  });

  final bool maintenanceMode;
  final ValueChanged<bool> onMaintenanceChanged;
  final void Function(String, {bool success}) onMessage;

  @override
  State<AdminSettingsPage> createState() =>
      _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  double _maxInstances = 5;
  double _storageMb = 512;
  double _inactivityDays = 7;

  bool _allowRegistrations = true;
  bool _googleLogin = true;
  bool _githubLogin = true;
  bool _automaticBackups = true;

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Configuración de la plataforma',
            subtitle:
                'Define límites, accesos y comportamiento global de Raft DB.',
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;

              final limits = AdminCard(
                padding: const EdgeInsets.all(23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingsHeader(
                      icon: Icons.tune_rounded,
                      title: 'Límites del plan gratuito',
                      description:
                          'Restricciones aplicadas a cada usuario.',
                    ),
                    const SizedBox(height: 23),
                    LimitSlider(
                      label: 'Instancias por usuario',
                      value: _maxInstances,
                      min: 1,
                      max: 10,
                      displayValue: '${_maxInstances.round()}',
                      onChanged: (value) {
                        setState(() => _maxInstances = value);
                      },
                    ),
                    LimitSlider(
                      label: 'Almacenamiento por instancia',
                      value: _storageMb,
                      min: 128,
                      max: 2048,
                      divisions: 15,
                      displayValue: '${_storageMb.round()} MB',
                      onChanged: (value) {
                        setState(() => _storageMb = value);
                      },
                    ),
                    LimitSlider(
                      label: 'Días antes de suspender por inactividad',
                      value: _inactivityDays,
                      min: 1,
                      max: 30,
                      displayValue: '${_inactivityDays.round()} días',
                      onChanged: (value) {
                        setState(() => _inactivityDays = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => widget.onMessage(
                          'Los límites fueron actualizados.',
                          success: true,
                        ),
                        child: const Text('Guardar límites'),
                      ),
                    ),
                  ],
                ),
              );

              final access = Column(
                children: [
                  AdminCard(
                    padding: const EdgeInsets.all(23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsHeader(
                          icon: Icons.login_rounded,
                          title: 'Registro y autenticación',
                          description:
                              'Métodos disponibles para acceder.',
                        ),
                        const SizedBox(height: 12),
                        SettingSwitch(
                          title: 'Permitir nuevos registros',
                          subtitle:
                              'Los visitantes pueden crear una cuenta.',
                          value: _allowRegistrations,
                          onChanged: (value) {
                            setState(() => _allowRegistrations = value);
                          },
                        ),
                        SettingSwitch(
                          title: 'Inicio de sesión con Google',
                          subtitle: 'OAuth mediante cuentas de Google.',
                          value: _googleLogin,
                          onChanged: (value) {
                            setState(() => _googleLogin = value);
                          },
                        ),
                        SettingSwitch(
                          title: 'Inicio de sesión con GitHub',
                          subtitle: 'OAuth mediante cuentas de GitHub.',
                          value: _githubLogin,
                          onChanged: (value) {
                            setState(() => _githubLogin = value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  AdminCard(
                    padding: const EdgeInsets.all(23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsHeader(
                          icon: Icons.cloud_sync_rounded,
                          title: 'Operación y mantenimiento',
                          description:
                              'Controles críticos de la plataforma.',
                        ),
                        const SizedBox(height: 12),
                        SettingSwitch(
                          title: 'Copias de seguridad automáticas',
                          subtitle: 'Respaldo diario de las instancias.',
                          value: _automaticBackups,
                          onChanged: (value) {
                            setState(() => _automaticBackups = value);
                          },
                        ),
                        SettingSwitch(
                          title: 'Modo mantenimiento',
                          subtitle:
                              'Restringe temporalmente el acceso de usuarios.',
                          value: widget.maintenanceMode,
                          dangerous: true,
                          onChanged: widget.onMaintenanceChanged,
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (!desktop) {
                return Column(
                  children: [
                    limits,
                    const SizedBox(height: 18),
                    access,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: limits),
                  const SizedBox(width: 18),
                  Expanded(child: access),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          AdminCard(
            padding: const EdgeInsets.all(23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsHeader(
                  icon: Icons.warning_amber_rounded,
                  title: 'Zona de peligro',
                  description:
                      'Acciones críticas que afectan toda la plataforma.',
                  color: AppColors.red,
                ),
                const SizedBox(height: 20),
                DangerAction(
                  title: 'Detener todas las instancias',
                  description:
                      'Apaga temporalmente todas las bases de datos.',
                  buttonText: 'Detener instancias',
                  onPressed: () => widget.onMessage(
                    'Esta acción requiere confirmación adicional.',
                  ),
                ),
                const Divider(height: 30),
                DangerAction(
                  title: 'Limpiar datos temporales',
                  description:
                      'Elimina caché, archivos temporales y registros antiguos.',
                  buttonText: 'Limpiar datos',
                  onPressed: () => widget.onMessage(
                    'Los datos temporales fueron eliminados.',
                    success: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}