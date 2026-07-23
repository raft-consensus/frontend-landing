import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/auth_background.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/register/register_card.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/register/register_presentation.dart';

/// Pantalla principal de Registro de Usuario.
/// Gestiona la animación de fondo, el estado del formulario y la respuesta según pantalla.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
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

    // Inicia la animación en bucle infinito del fondo 2D (dura 16s cada ciclo)
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

  /// Procesa el envío del formulario de registro
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

    // Simula la llamada a la API de registro
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

  /// Maneja el registro con redes sociales
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
      backgroundColor: const Color(0xFF031126),
      body: Stack(
        children: [
          // 1. Fondo animado con CustomPaint
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

          // 2. Botón flotante para regresar al inicio (Landing Page)
          Positioned(
            top: 22,
            left: 22,
            child: SafeArea(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Volver al inicio'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                ),
              ),
            ),
          ),

          // 3. Contenido principal centrado con animación de entrada
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
                            // Vista Escritorio (Row): Presentación a la izquierda, tarjeta a la derecha
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
                            // Vista Móvil (Column): Marca arriba, tarjeta al centro abajo
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
