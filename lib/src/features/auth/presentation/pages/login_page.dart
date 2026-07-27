import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/login_form_data.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/auth_background.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/login/login_card.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/login/login_presentation.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Pantalla principal de Inicio de Sesión (Login).
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _backgroundController;

  bool _hidePassword = true;
  bool _rememberMe = false;

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
  /// Procesa el inicio de sesión del usuario y navega al Dashboard
  /// Procesa el inicio de sesión del usuario conectando con la API a través de Riverpod.
  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    // 1. Construye el DTO con email, contraseña y recordar sesión
    final formData = LoginFormData(
      email: _emailController.text,
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    // 2. Invoca el login en el notificador de estado
    final success = await ref.read(authProvider.notifier).login(formData);

    if (!mounted) return;

    // 3. Si el servidor responde exitosamente, navega al dashboard
    if (success) {
      // Consulta el rol del usuario autenticado ('Admin' o 'User')
      final userRole = ref.read(authProvider).session?.user.role ?? 'User';
      final destination = (userRole == 'Admin') ? '/admin' : '/dashboard';
      // Navega al panel correspondiente según el rol
      context.go(destination);
    } else {
      final errorMessage =
          ref.read(authProvider).errorMessage ?? 'Error al iniciar sesión.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  /// Maneja el inicio de sesión social redirigiendo al proveedor OAuth (Web y Móvil)
  Future<void> _socialLogin(String provider) async {
    final baseUrl = ApiClient.baseUrl;
    final providerEndpoint = provider.toLowerCase();

    // 1. Construye la URL OAuth del backend
    final oauthUrl = Uri.parse('$baseUrl/api/auth/login/$providerEndpoint');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redirigiendo a $provider...'),
        backgroundColor: const Color(0xFF118A61),
      ),
    );

    // 2. Abre la URL en el navegador del dispositivo (funciona en Web, Android e iOS)
    if (await canLaunchUrl(oauthUrl)) {
      await launchUrl(oauthUrl, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo abrir la navegación a $provider'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  /// Abre la recuperación de contraseña
  void _recoverPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abrir recuperación de contraseña.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
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
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
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
                                  const Expanded(child: LoginPresentation()),
                                  const SizedBox(width: 75),
                                  SizedBox(
                                    width: 460,
                                    child: LoginCard(
                                      formKey: _formKey,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      hidePassword: _hidePassword,
                                      rememberMe: _rememberMe,
                                      loading: authState.isLoading,
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
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                    ),
                                    child: LoginCard(
                                      formKey: _formKey,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      hidePassword: _hidePassword,
                                      rememberMe: _rememberMe,
                                      loading: authState.isLoading,
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
