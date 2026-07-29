// ==========================================
// Archivo: lib/src/features/auth/presentation/pages/auth_callback_page.dart
// Qué hace: Captura el redireccionamiento de Google/GitHub OAuth, extrae el token del hash de la URL y lo guarda.
// Dónde se conecta: Registrada en GoRouter como la ruta '/auth/callback'.
// De dónde recibe: Redirección del navegador enviada por el backend (Uri.base.fragment).
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

/// Pantalla encargada de procesar la respuesta del callback OAuth.
class AuthCallbackPage extends ConsumerStatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  ConsumerState<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends ConsumerState<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    // Ejecuta la lectura de la URL una vez que el frame inicial ha sido renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleCallback();
    });
  }

  /// Lee los parámetros del Query String (?) de la URL y autentica la sesión
  Future<void> _handleCallback() async {
    final currentUri = Uri.base;

    // 1. Extrae el token directamente de los query parameters (?) enviados por el backend
    final token = currentUri.queryParameters['access_token'] ?? currentUri.queryParameters['token'];
    final provider = currentUri.queryParameters['provider'] ?? 'Google';
    final error = currentUri.queryParameters['error'];

    // 2. Si el proveedor reportó un error, se lo mostramos al usuario y volvemos a /login
    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión con OAuth: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
      context.go('/login');
      return;
    }

    // 3. Si el token llegó correctamente, lo guardamos en la sesión global
    if (token != null && token.isNotEmpty) {
      final success = await ref
          .read(authProvider.notifier)
          .setSessionFromOAuth(token, provider);

      if (!mounted) return;

      // 4. Al guardar el token con éxito, redirigimos según el rol del usuario ('Admin' o 'User')
      if (success) {
        final role = ref.read(authProvider).session?.user.role ?? 'User';
        final destination = (role == 'Admin') ? '/admin' : '/dashboard';
        context.go(destination);
      } else {
        context.go('/login');
      }
    } else {
      // 5. Si no había ningún token en la URL, devolvemos al usuario a /login
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se recibió un token de autenticación válido.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      context.go('/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF031126),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Autenticando y procesando tu sesión...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
