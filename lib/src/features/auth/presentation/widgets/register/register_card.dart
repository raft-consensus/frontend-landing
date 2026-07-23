import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/auth_divider.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/field_label.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/social_button.dart';

/// Tarjeta blanca de formulario de registro de usuario.
class RegisterCard extends StatelessWidget {
  const RegisterCard({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.hidePassword,
    required this.acceptTerms,
    required this.loading,
    required this.onTogglePassword,
    required this.onTermsChanged,
    required this.onRegister,
    required this.onGoogle,
    required this.onGithub,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool hidePassword;
  final bool acceptTerms;
  final bool loading;

  final VoidCallback onTogglePassword;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onRegister;
  final VoidCallback onGoogle;
  final VoidCallback onGithub;

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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crea tu cuenta',
              style: TextStyle(
                color: Color(0xFF10233F),
                fontSize: 29,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Comienza a utilizar Raft DB gratuitamente.',
              style: TextStyle(color: Color(0xFF687A91), fontSize: 14),
            ),
            const SizedBox(height: 25),

            // Botones de autenticación social
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
            const SizedBox(height: 24),
            const AuthDivider(label: 'o regístrate con correo'),
            const SizedBox(height: 24),

            // Campo Nombre
            const FieldLabel('Nombre'),
            const SizedBox(height: 8),
            TextFormField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              decoration: const InputDecoration(
                hintText: 'Tu nombre completo',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa tu nombre.';
                }
                if (value.trim().length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

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
            const SizedBox(height: 18),

            // Campo Contraseña
            const FieldLabel('Contraseña'),
            const SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              obscureText: hidePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (_) => onRegister(),
              decoration: InputDecoration(
                hintText: 'Mínimo 8 caracteres',
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
                  return 'Ingresa una contraseña.';
                }
                if (value.length < 8) {
                  return 'Utiliza al menos 8 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 15,
                  color: Color(0xFF687A91),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Utiliza letras, números y un símbolo.',
                    style: TextStyle(color: Color(0xFF687A91), fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),

            // Checkbox de Términos
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: acceptTerms,
                    activeColor: AppColors.blue,
                    onChanged: onTermsChanged,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: Color(0xFF687A91),
                        fontSize: 12,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'Acepto los '),
                        TextSpan(
                          text: 'términos de uso',
                          style: TextStyle(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(text: ' y la '),
                        TextSpan(
                          text: 'política de privacidad',
                          style: TextStyle(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Botón de Enviar (Submit)
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: loading ? null : onRegister,
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
                              'Crear cuenta',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(width: 9),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 23),

            // Enlace a Login
            Center(
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF687A91),
                    fontSize: 13,
                  ),
                  children: [
                    const TextSpan(text: '¿Ya tienes una cuenta? '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Iniciar sesión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
