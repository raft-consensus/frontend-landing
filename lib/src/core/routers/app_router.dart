import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:frontend_landing/src/features/auth/presentation/pages/auth_callback_page.dart';
import 'package:frontend_landing/src/features/auth/presentation/pages/login_page.dart';
import 'package:frontend_landing/src/features/auth/presentation/pages/register_page.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/landing/presentation/pages/landing_page.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/dashboard_page.dart';
import 'package:go_router/go_router.dart';

/// Proveedor de Riverpod que genera y administra las rutas declarativas de la app.
///
/// ¿De dónde recibe datos?: Escucha el estado de sesión de authProvider mediante refreshListenable.
/// ¿Hacia dónde va / Dónde se conecta?: Consumido por MaterialApp.router en main.dart para navegación y redirecciones.
final routerProvider = Provider<GoRouter>((ref) {
  // Notificador que avisa a GoRouter cuando cambia la sesión sin destruir la instancia
  final refreshNotifier = ValueNotifier<int>(0);

  // Liberación de memoria cuando se destruye el provider
  ref.onDispose(refreshNotifier.dispose);

  ref.listen<AuthState>(authProvider, (previous, next) {
    refreshNotifier.value++;
  });

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      // Excepción: Si la ruta es el callback de OAuth, permitir que procese el token sin interferir
      if (state.matchedLocation == '/auth/callback') {
        return null;
      }

      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isProtectedRoute =
          state.matchedLocation.startsWith('/dashboard') ||
          state.matchedLocation.startsWith('/admin');

      // Determina el destino según el rol del usuario ('Admin' vs 'User')
      final userRole = authState.session?.user.role ?? 'User';
      final defaultDashboard = (userRole == 'Admin') ? '/admin' : '/dashboard';

      // Regla 1: Si NO está autenticado e intenta acceder a zonas privadas -> Redirigir a /login
      if (!isAuthenticated && isProtectedRoute) {
        return '/login';
      }

      // Regla 2: Si YA está autenticado e intenta ir a login o registro -> Redirigir a su panel por defecto
      if (isAuthenticated && isAuthRoute) {
        return defaultDashboard;
      }

      // Regla 3: Si un usuario regular ('User') intenta ingresar al panel de administración -> Redirigir a /dashboard
      if (isAuthenticated &&
          userRole != 'Admin' &&
          state.matchedLocation.startsWith('/admin')) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => LandingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),

      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/auth/callback',
        name: 'auth_callback',
        builder: (context, state) => const AuthCallbackPage(),
      ),
    ],
  );
});
