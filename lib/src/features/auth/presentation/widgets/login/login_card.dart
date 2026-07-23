import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/auth/presentation/screens/register_screen.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/auth_divider.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/field_label.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/social_button.dart';

/// Tarjeta blanca de formulario para Inicio de Sesión (Login).
class LoginCard extends StatelessWidget {
  const LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.hidePassword,
    required this.rememberMe,
    required this.loading,
    required this.onTogglePassword,
    required this.onRememberChanged,
    required this.onLogin,
    required this.onGoogle,
    required this.onGithub,
    required this.onRecoverPassword,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool hidePassword;
  final bool rememberMe;
  final bool loading;

  final VoidCallback onTogglePassword;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback onLogin;
  final VoidCallback onGoogle;
  final VoidCallback onGithub;
  final VoidCallback onRecoverPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: Colors.white.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: 55,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: AutofillGroup(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Inicia sesión',
                style: TextStyle(
                  color: Color(0xFF10233F),
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Accede a tus bases de datos y herramientas.',
                style: TextStyle(
                  color: Color(0xFF687A91),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 26),

              // Botones sociales
              Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      iconColor: const Color(0xFF4285F4),
                      onPressed: onGoogle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SocialButton(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      iconColor: const Color(0xFF172033),
                      onPressed: onGithub,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              const AuthDivider(label: 'o continúa con tu correo'),
              const SizedBox(height: 24),

              // Campo Correo electrónico
              const FieldLabel('Correo electrónico'),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  hintText: 'nombre@correo.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) {
                    return 'Ingresa tu correo.';
                  }
                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Ingresa un correo válido.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 19),

              // Campo Contraseña
              const FieldLabel('Contraseña'),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: hidePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => onLogin(),
                decoration: InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: hidePassword
                        ? 'Mostrar contraseña'
                        : 'Ocultar contraseña',
                    onPressed: onTogglePassword,
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu contraseña.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 13),

              // Checkbox Recordarme y Recuperación de Contraseña
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: rememberMe,
                      activeColor: AppColors.blue,
                      onChanged: onRememberChanged,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Text(
                    'Recordarme',
                    style: TextStyle(
                      color: Color(0xFF687A91),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onRecoverPassword,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Botón Submit Iniciar Sesión
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: loading ? null : onLogin,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF738097),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: loading
                        ? const SizedBox(
                            key: ValueKey('loader'),
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            key: ValueKey('label'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 9),
                              Icon(Icons.login_rounded, size: 20),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Enlace alternar a Registro
              Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF687A91),
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: '¿Aún no tienes una cuenta? '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          onTap: () {
                            // Reemplaza la pantalla actual de Login por Registro
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Regístrate gratis',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
