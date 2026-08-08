import 'package:flutter/material.dart';

/// ¿Qué hace?: Renderiza los íconos oficiales transparentes en alta definición desde lib/src/img/in/ para MySQL, SQL Server, MongoDB y PostgreSQL.
/// ¿De dónde trae datos?: Ingesta la ruta lib/src/img/in/[engine].png y ajusta la escala según el modo de renderizado.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en las tarjetas de bases de datos y diálogos de selección.
class EngineIcon extends StatelessWidget {
  const EngineIcon({
    required this.icon,    // Icono fallback
    required this.color,   // Color de marca oficial
    this.engineName = '',  // Nombre del motor para mapear la imagen PNG (ej: "MySQL", "PostgreSQL")
    this.small = false,    // Define si el tamaño es reducido (34px) o grande (44px)
    super.key,
  });

  final IconData icon;
  final Color color;
  final String engineName;
  final bool small;

  @override
  Widget build(BuildContext context) {
    // 1. Tamaño del logo optimizado para legibilidad nítida
    final size = small ? 34.0 : 44.0;

    // 2. Normaliza la cadena para seleccionar la imagen en lib/src/img/in/
    final normalized = engineName.toLowerCase().replaceAll(' ', '');
    String assetPath = '';

    // Evalúa PostgreSQL primero para evitar falsos positivos con la palabra "sql"
    if (normalized.contains('postgres') || normalized.contains('pg')) {
      assetPath = 'lib/src/img/in/postgresql.png';
    } else if (normalized.contains('mysql')) {
      assetPath = 'lib/src/img/in/mysql.png';
    } else if (normalized.contains('mongo')) {
      assetPath = 'lib/src/img/in/mongodb.png';
    } else if (normalized.contains('sqlserver') || normalized.contains('sql')) {
      assetPath = 'lib/src/img/in/sqlserver.png';
    }

    // 3. Si existe la imagen PNG transparente, la dibuja nítida en alta calidad
    if (assetPath.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high, // Alta definición sin distorsión de píxeles
          errorBuilder: (context, error, stackTrace) => _FallbackIcon(
            icon: icon,
            color: color,
            size: size,
          ),
        ),
      );
    }

    return _FallbackIcon(icon: icon, color: color, size: size);
  }
}

/// Sub-widget privado: Icono fallback por si la imagen PNG no carga
class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: size * 0.6),
    );
  }
}
