import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/auth_background.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/login/login_card.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/login/login_presentation.dart';
import 'package:go_router/go_router.dart';

/// Pantalla principal de Inicio de Sesión (Login).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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

    // Inicia la animación continua del fondo 2D
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

  /// Procesa el inicio de sesión del usuario
  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // Simula la llamada de inicio de sesión a la API
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

  /// Maneja el inicio de sesión social
  void _socialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciar sesión con $provider'),
      ),
    );
  }

  /// Abre la recuperación de contraseña
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
      backgroundColor: const Color(0xFF031126),
      body: Stack(
        children: [
          // 1. Fondo animado de la red de base de datos
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

          // 2. Botón para volver a la Landing Page
          Positioned(
            top: 22,
            left: 22,
            child: SafeArea(
              child: TextButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Volver al inicio'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                ),
              ),
            ),
          ),

          // 3. Formulario y presentación responsiva
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
                            // Vista Escritorio (Row): Presentación a la izquierda, Tarjeta a la derecha
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
                            // Vista Móvil (Column): Marca arriba, Tarjeta al centro abajo
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
