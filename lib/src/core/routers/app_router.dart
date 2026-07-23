import 'package:go_router/go_router.dart';
import 'package:frontend_landing/src/features/landing/presentation/screens/landing_screen.dart';
import 'package:frontend_landing/src/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend_landing/src/features/auth/presentation/screens/register_screen.dart';

/// Configuración centralizada de las rutas del frontend de la aplicación.
abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}
