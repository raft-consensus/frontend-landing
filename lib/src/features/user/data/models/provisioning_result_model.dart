// ==========================================
// Archivo: lib/src/features/user/data/models/provisioning_result_model.dart
// Qué hace: Mapea la respuesta JSON de POST /api/me/databases (MySqlProvisioningResultDto).
// Dónde se conecta: Consumido por UserDatabasesRemoteDatasource y UserDatabasesNotifier.
// De dónde recibe datos: Deserializa la respuesta del backend ASP.NET Core.
//
// Importante: la contraseña en texto plano solo viene en ESTA respuesta. El backend la
// cifra inmediatamente después de guardarla, así que no existe otro endpoint que la vuelva
// a exponer en texto plano (el reveal de /password sí puede recuperarla, ver
// UserDatabasesRemoteDatasource.revealPassword, porque el backend guarda una copia cifrada
// reversible — pero esta respuesta de creación es la única vez que llega "gratis").
// ==========================================

class ProvisioningResultModel {
  final int databaseInstanceId;
  final String host;
  final int port;
  final String databaseName;
  final String databaseUser;
  final String password;
  final String engine;

  ProvisioningResultModel({
    required this.databaseInstanceId,
    required this.host,
    required this.port,
    required this.databaseName,
    required this.databaseUser,
    required this.password,
    required this.engine,
  });

  factory ProvisioningResultModel.fromJson(Map<String, dynamic> json) {
    return ProvisioningResultModel(
      databaseInstanceId: json['databaseInstanceId'] ?? 0,
      host: json['host'] ?? '',
      port: json['port'] ?? 3306,
      databaseName: json['databaseName'] ?? '',
      databaseUser: json['databaseUser'] ?? '',
      password: json['password'] ?? '',
      engine: json['engine'] ?? 'MySQL',
    );
  }
}
