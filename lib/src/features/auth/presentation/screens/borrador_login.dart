import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const LoginApp());
}

class AppColors {
  static const navy = Color(0xFF061A3A);
  static const deepNavy = Color(0xFF031126);
  static const blue = Color(0xFF1378E5);
  static const cyan = Color(0xFF16D2C8);
  static const green = Color(0xFF17B778);
  static const text = Color(0xFF10233F);
  static const muted = Color(0xFF687A91);
  static const border = Color(0xFFDDE6F0);
  static const field = Color(0xFFF6F9FC);
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login | Raft DB',
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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _backgroundController;

  bool _hidePassword = true;
  bool _rememberMe = false;
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
    _emailController.dispose();
    _passwordController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 1100));

    if (!mounted) return;

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión iniciada correctamente.'),
        backgroundColor: Color(0xFF118A61),
      ),
    );
  }

  void _socialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciar sesión con $provider'),
      ),
    );
  }

  void _recoverPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrir recuperación de contraseña.'),
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
                  painter: LoginBackgroundPainter(
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
                  constraints: const BoxConstraints(maxWidth: 1120),
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
                                    child: LoginPresentation(),
                                  ),
                                  const SizedBox(width: 75),
                                  SizedBox(
                                    width: 460,
                                    child: LoginCard(
                                      formKey: _formKey,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      hidePassword: _hidePassword,
                                      rememberMe: _rememberMe,
                                      loading: _loading,
                                      onTogglePassword: () {
                                        setState(() {
                                          _hidePassword = !_hidePassword;
                                        });
                                      },
                                      onRememberChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      onLogin: _login,
                                      onGoogle: () => _socialLogin('Google'),
                                      onGithub: () => _socialLogin('GitHub'),
                                      onRecoverPassword: _recoverPassword,
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
                                    child: LoginCard(
                                      formKey: _formKey,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      hidePassword: _hidePassword,
                                      rememberMe: _rememberMe,
                                      loading: _loading,
                                      onTogglePassword: () {
                                        setState(() {
                                          _hidePassword = !_hidePassword;
                                        });
                                      },
                                      onRememberChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      onLogin: _login,
                                      onGoogle: () => _socialLogin('Google'),
                                      onGithub: () => _socialLogin('GitHub'),
                                      onRecoverPassword: _recoverPassword,
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

// =============================================================================
// PRESENTACIÓN
// =============================================================================

class LoginPresentation extends StatelessWidget {
  const LoginPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RaftLogo(),
        const SizedBox(height: 58),
        const StatusPill(),
        const SizedBox(height: 25),
        const Text(
          'Regresa a bordo\ny sigue construyendo.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 52,
            height: 1.06,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 525),
          child: const Text(
            'Accede a tus instancias, credenciales y herramientas '
            'desde un panel diseñado para trabajar sin complicaciones.',
            style: TextStyle(
              color: Color(0xFFB4C5DA),
              fontSize: 17,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 38),
        const PlatformPreview(),
      ],
    );
  }
}

class PlatformPreview extends StatelessWidget {
  const PlatformPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.055),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: const Column(
          children: [
            PreviewHeader(),
            SizedBox(height: 15),
            PreviewInstance(
              name: 'proyecto-universidad',
              engine: 'PostgreSQL',
              color: Color(0xFF45A7E8),
            ),
            SizedBox(height: 10),
            PreviewInstance(
              name: 'api-tienda',
              engine: 'MongoDB',
              color: Color(0xFF26C978),
            ),
          ],
        ),
      ),
    );
  }
}

class PreviewHeader extends StatelessWidget {
  const PreviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.dashboard_rounded,
          color: AppColors.cyan,
          size: 20,
        ),
        SizedBox(width: 9),
        Text(
          'Tus bases de datos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        Spacer(),
        Text(
          '2 activas',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class PreviewInstance extends StatelessWidget {
  const PreviewInstance({
    required this.name,
    required this.engine,
    required this.color,
    super.key,
  });

  final String name;
  final String engine;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.065),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: color.withOpacity(0.17),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.storage_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  engine,
                  style: const TextStyle(
                    color: Color(0xFF91A6C0),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '● Activa',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
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
          'Accede a tu panel de Raft DB',
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
        color: AppColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.green.withOpacity(0.25),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: AppColors.green,
          ),
          SizedBox(width: 8),
          Text(
            'SERVICIOS DISPONIBLES',
            style: TextStyle(
              color: AppColors.green,
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

// =============================================================================
// TARJETA LOGIN
// =============================================================================

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
                  color: AppColors.text,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Accede a tus bases de datos y herramientas.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 26),

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
                      color: AppColors.muted,
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
              Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: '¿Aún no tienes una cuenta? '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          onTap: () {},
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

// =============================================================================
// FONDO TECNOLÓGICO ANIMADO
// =============================================================================

class LoginBackgroundPainter extends CustomPainter {
  LoginBackgroundPainter({required this.progress});

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
          Color(0xFF073256),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, background);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.blue.withOpacity(0.13),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.75, size.height * 0.25),
          radius: size.width * 0.42,
        ),
      );

    canvas.drawRect(Offset.zero & size, glowPaint);

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 1;

    const spacing = 58.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final nodes = <Offset>[
      Offset(size.width * 0.05, size.height * 0.22),
      Offset(size.width * 0.17, size.height * 0.39),
      Offset(size.width * 0.09, size.height * 0.73),
      Offset(size.width * 0.32, size.height * 0.87),
      Offset(size.width * 0.45, size.height * 0.64),
      Offset(size.width * 0.58, size.height * 0.21),
      Offset(size.width * 0.79, size.height * 0.10),
      Offset(size.width * 0.92, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.78),
      Offset(size.width * 0.97, size.height * 0.91),
    ];

    final connector = Paint()
      ..color = AppColors.cyan.withOpacity(0.09)
      ..strokeWidth = 1.2;

    for (int i = 0; i < nodes.length - 1; i++) {
      canvas.drawLine(nodes[i], nodes[i + 1], connector);
    }

    for (int i = 0; i < nodes.length; i++) {
      final pulse =
          2.5 + math.sin(progress * math.pi * 2 + i).abs() * 2.7;

      canvas.drawCircle(
        nodes[i],
        pulse + 7,
        Paint()..color = AppColors.cyan.withOpacity(0.04),
      );

      canvas.drawCircle(
        nodes[i],
        pulse,
        Paint()..color = AppColors.cyan.withOpacity(0.30),
      );
    }

    _drawDatabase(
      canvas,
      Offset(size.width * 0.12, size.height * 0.57),
      48,
    );

    _drawDatabase(
      canvas,
      Offset(size.width * 0.89, size.height * 0.55),
      38,
    );
  }

  void _drawDatabase(
    Canvas canvas,
    Offset center,
    double width,
  ) {
    final fill = Paint()
      ..color = AppColors.blue.withOpacity(0.07)
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = AppColors.cyan.withOpacity(0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: width * 1.18,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      fill,
    );

    for (int i = 0; i < 3; i++) {
      final y = rect.top + 7 + i * ((rect.height - 14) / 2);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, y),
          width: width,
          height: 13,
        ),
        stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LoginBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
