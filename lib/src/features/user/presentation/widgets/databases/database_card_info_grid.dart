// ==========================================
// Qué hace: Muestra la grilla de detalles de conexión (Host, Puerto, BD y Usuario) en la tarjeta de BD.
// Dónde se conecta: Importado por DatabaseManagementCard.
// De dónde recibe datos: Recibe la entidad DatabaseInstance.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_line.dart'; // Common

/// Grilla de información de conexión ordenada en 2 filas con iconos de red y servidor
class DatabaseCardInfoGrid extends StatelessWidget {
  const DatabaseCardInfoGrid({
    required this.instance, // Instancia con host, puerto, nombre de BD y usuario
    super.key,
  });

  final DatabaseInstance instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoLine(
                icon: Icons.dns_rounded,
                label: 'Host',
                value: instance.host,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoLine(
                icon: Icons.numbers_rounded,
                label: 'Puerto',
                value: '${instance.port}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InfoLine(
                icon: Icons.storage_rounded,
                label: 'BD',
                value: instance.database,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoLine(
                icon: Icons.person_rounded,
                label: 'Usuario',
                value: instance.username,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
