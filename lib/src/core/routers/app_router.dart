import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:frontend_landing/src/features/auth/presentation/pages/login_page.dart';
import 'package:frontend_landing/src/features/auth/presentation/pages/register_page.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/landing/presentation/pages/landing_page.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/dashboard_page.dart';
import 'package:go_router/go_router.dart';

/// Proveedor de Riverpod que genera y administra las rutas declarativas de la app.
/// 
/// ¿De dónde recibe datos?: Escucha el estado de sesión de authProvider.
/// ¿Hacia dónde va / Dónde se conecta?: Consumido por MaterialApp.router en main.dart para navegación y redirecciones.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {

      // return null; // quitar cuando ya se vaya a dejar

      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isProtectedRoute = state.matchedLocation.startsWith('/dashboard');

      // Regla 1: Bloquea acceso a rutas privadas si no hay sesión
      if (!isAuthenticated && isProtectedRoute) {
        return '/login';
      }

      // Regla 2: Redirige al dashboard si ya inició sesión e intenta ir a login/registro
      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      // Permite la navegación normal para rutas públicas como '/'
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
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
      )
      
    ],
  );
});
