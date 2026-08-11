import 'dart:convert';
import 'package:frontend_landing/src/features/auth/domain/entities/auth_user.dart';

/// Utilidad centralizada para decodificar y validar Tokens JWT.
/// 
/// ¿Qué hace?: Decodifica el payload en base64 de un JWT, extrae claims de usuario y verifica su expiración.
/// ¿De dónde recibe datos?: Cadenas de Token JWT pasadas desde el provider o repositorio.
/// ¿Hacia dónde se conecta?: Utilizado por AuthNotifier.
class JwtDecoder {
  /// Verifica si la fecha de expiración ('exp') del JWT ya se cumplió.
  static bool isExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decodedString = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> claims = jsonDecode(decodedString);

      if (claims.containsKey('exp')) {
        final expTimestamp = claims['exp'] as int;
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(expTimestamp * 1000);
        return DateTime.now().isAfter(expiryDate);
      }
      return false;
    } catch (_) {
      return true; // Ante cualquier error de parseo se asume expirado
    }
  }

  /// Parsea el payload del JWT soportando claims estándar y de ASP.NET Core.
  static AuthUser parseUser(String token, String provider) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('JWT inválido');

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decodedString = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> claims = jsonDecode(decodedString);

      // Mapeo del claim de Rol
      final roleClaim = claims['role'] ??
          claims['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
          'User';

      // Mapeo del claim de ID
      final idClaim = claims['sub'] ??
          claims['nameid'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
          '0';

      // Mapeo del claim de Nombre
      final nameClaim = claims['name'] ??
          claims['unique_name'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ??
          'Usuario $provider';

      // Mapeo del claim de Email
      final emailClaim = claims['email'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
          '';

      return AuthUser(
        id: idClaim.toString(),
        name: nameClaim.toString(),
        email: emailClaim.toString(),
        role: roleClaim.toString(),
      );
    } catch (_) {
      return AuthUser(
        id: '0',
        name: 'Usuario $provider',
        email: '',
        role: 'User',
      );
    }
  }
}
