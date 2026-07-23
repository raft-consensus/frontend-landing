import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const RegisterApp());
}

class AppColors {
  static const navy = Color(0xFF061A3A);
  static const deepNavy = Color(0xFF031126);
  static const blue = Color(0xFF1378E5);
  static const cyan = Color(0xFF16D2C8);
  static const text = Color(0xFF10233F);
  static const muted = Color(0xFF687A91);
  static const border = Color(0xFFDDE6F0);
  static const field = Color(0xFFF6F9FC);
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro | Raft DB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          primary: AppColors.navy,
        ),
        scaffoldBackgroundColor: AppColors.deepNavy,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.field,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 18,
          ),
          labelStyle: const TextStyle(color: AppColors.muted),
          hintStyle: const TextStyle(color: Color(0xFF9AA9BA)),
          prefixIconColor: const Color(0xFF71839A),
          suffixIconColor: const Color(0xFF71839A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.blue,
              width: 1.8,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE24C5B)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE24C5B),
              width: 1.8,
            ),
          ),
        ),
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _backgroundController;

  bool _hidePassword = true;
  bool _acceptTerms = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes aceptar los términos y la política de privacidad.',
          ),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 1100));

    if (!mounted) return;

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cuenta creada correctamente.'),
        backgroundColor: Color(0xFF118A61),
      ),
    );
  }

  void _socialRegister(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Continuar registro con $provider'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return CustomPaint(
                  painter: DatabaseBackgroundPainter(
                    progress: _backgroundController.value,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 22,
            left: 22,
            child: SafeArea(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Volver al inicio'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 78, 24, 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1140),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final desktop = constraints.maxWidth >= 900;

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: desktop
                            ? Row(
                                children: [
                                  const Expanded(
                                    child: RegisterPresentation(),
                                  ),
                                  const SizedBox(width: 70),
                                  SizedBox(
                                    width: 470,
                                    child: RegisterCard(
                                      formKey: _formKey,
                                      nameController: _nameController,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      hidePassword: _hidePassword,
                                      acceptTerms: _acceptTerms,
                                      loading: _loading,
                                      onTogglePassword: () {
                                        setState(() {
                                          _hidePassword = !_hidePassword;
                                        });
                                      },
                                      onTermsChanged: (value) {
                                        setState(() {
                                          _acceptTerms = value ?? false;
                                        });
                                      },
                                      onRegister: _register,
                                      onGoogle: () =>
                                          _socialRegister('Google'),
                                      onGithub: () =>
                                          _socialRegister('GitHub'),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  const MobileBrand(),
                                  const SizedBox(height: 28),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 500),
                                    child: RegisterCard(
                                      formKey: _formKey,
                                      nameController: _nameController,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      hidePassword: _hidePassword,
                                      acceptTerms: _acceptTerms,
                                      loading: _loading,
                                      onTogglePassword: () {
                                        setState(() {
                                          _hidePassword = !_hidePassword;
                                        });
                                      },
                                      onTermsChanged: (value) {
                                        setState(() {
                                          _acceptTerms = value ?? false;
                                        });
                                      },
                                      onRegister: _register,
                                      onGoogle: () =>
                                          _socialRegister('Google'),
                                      onGithub: () =>
                                          _socialRegister('GitHub'),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterPresentation extends StatelessWidget {
  const RegisterPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RaftLogo(),
        SizedBox(height: 52),
        StatusPill(),
        SizedBox(height: 25),
        Text(
          'Tu próxima idea\ncomienza con datos.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 54,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),
        SizedBox(height: 22),
        Text(
          'Crea una cuenta gratuita y despliega bases de datos '
          'para tus prácticas, prototipos y proyectos de desarrollo.',
          style: TextStyle(
            color: Color(0xFFB4C5DA),
            fontSize: 17,
            height: 1.65,
          ),
        ),
        SizedBox(height: 35),
        FeatureItem(
          icon: Icons.bolt_rounded,
          title: 'Configuración rápida',
          description: 'Tu instancia estará lista en pocos minutos.',
        ),
        SizedBox(height: 18),
        FeatureItem(
          icon: Icons.storage_rounded,
          title: 'Cuatro motores disponibles',
          description: 'MySQL, PostgreSQL, SQL Server y MongoDB.',
        ),
        SizedBox(height: 18),
        FeatureItem(
          icon: Icons.shield_rounded,
          title: 'Entorno seguro',
          description: 'Credenciales independientes para cada instancia.',
        ),
      ],
    );
  }
}

class MobileBrand extends StatelessWidget {
  const MobileBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        RaftLogo(),
        SizedBox(height: 15),
        Text(
          'Crea tu cuenta gratuita',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFB4C5DA),
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class RaftLogo extends StatelessWidget {
  const RaftLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.cyan, AppColors.blue],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: const Icon(
            Icons.sailing_rounded,
            color: Colors.white,
            size: 29,
          ),
        ),
        const SizedBox(width: 11),
        const Text(
          'Raft',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(width: 3),
        const Text(
          'DB',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: 27,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.cyan.withOpacity(0.25),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: AppColors.cyan,
          ),
          SizedBox(width: 8),
          Text(
            'REGISTRO GRATUITO',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF91A5BF),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
                color: AppColors.text,
                fontSize: 29,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Comienza a utilizar Raft DB gratuitamente.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),
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
                  color: AppColors.muted,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Utiliza letras, números y un símbolo.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
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
                        color: AppColors.muted,
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
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 9),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 23),
            Center(
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                  ),
                  children: [
                    const TextSpan(text: '¿Ya tienes una cuenta? '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: InkWell(
                        onTap: () {},
                        child: const Text(
                          'Inicia sesión',
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
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor, size: 24),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

class DatabaseBackgroundPainter extends CustomPainter {
  DatabaseBackgroundPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.deepNavy,
          AppColors.navy,
          Color(0xFF062B51),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, background);

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 1;

    const spacing = 55.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final nodes = <Offset>[
      Offset(size.width * 0.08, size.height * 0.20),
      Offset(size.width * 0.20, size.height * 0.38),
      Offset(size.width * 0.10, size.height * 0.72),
      Offset(size.width * 0.34, size.height * 0.81),
      Offset(size.width * 0.46, size.height * 0.20),
      Offset(size.width * 0.76, size.height * 0.12),
      Offset(size.width * 0.91, size.height * 0.35),
      Offset(size.width * 0.82, size.height * 0.75),
      Offset(size.width * 0.96, size.height * 0.89),
    ];

    final linePaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.10)
      ..strokeWidth = 1.2;

    for (int i = 0; i < nodes.length - 1; i++) {
      canvas.drawLine(nodes[i], nodes[i + 1], linePaint);
    }

    for (int i = 0; i < nodes.length; i++) {
      final pulse = 2.5 +
          math.sin((progress * math.pi * 2) + i * 0.8).abs() * 2.5;

      canvas.drawCircle(
        nodes[i],
        pulse + 5,
        Paint()..color = AppColors.cyan.withOpacity(0.05),
      );

      canvas.drawCircle(
        nodes[i],
        pulse,
        Paint()..color = AppColors.cyan.withOpacity(0.35),
      );
    }

    _drawDatabase(
      canvas,
      Offset(size.width * 0.11, size.height * 0.52),
      44,
    );

    _drawDatabase(
      canvas,
      Offset(size.width * 0.88, size.height * 0.56),
      36,
    );
  }

  void _drawDatabase(
    Canvas canvas,
    Offset center,
    double width,
  ) {
    final paint = Paint()
      ..color = AppColors.blue.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = AppColors.cyan.withOpacity(0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: width * 1.15,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, rect.top + 5),
        width: width,
        height: 13,
      ),
      stroke,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy),
        width: width,
        height: 13,
      ),
      stroke,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, rect.bottom - 5),
        width: width,
        height: 13,
      ),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant DatabaseBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}