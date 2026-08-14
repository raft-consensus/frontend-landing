// ==========================================
// Qué hace: Pide confirmación y revoca un subdominio DNS en Cloudflare y backend.
// Dónde se conecta: Invocado desde las filas de DnsTable en DnsSslPage.
// De dónde recibe datos: Recibe BuildContext, WidgetRef, DnsRecord y callback onMessage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_dns_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart';

/// Acción encargada de la revocación y eliminación de registros DNS
abstract class DnsDeleteAction {
  /// Solicita confirmación y ejecuta la eliminación en el proveedor
  static Future<void> execute({
    required BuildContext context, // Contexto visual
    required WidgetRef ref, // Referencia Riverpod
    required DnsRecord record, // Registro a eliminar
    required void Function(String message, {bool success}) onMessage, // Notificador
  }) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Eliminar Registro DNS',
      message: '¿Estás seguro de que deseas eliminar el subdominio ${record.fqdn}?',
      confirmLabel: 'Sí, eliminar',
      icon: Icons.delete_forever_rounded,
    );

    if (!confirmed) return;

    final error = await ref.read(userDnsProvider.notifier).deleteRecord(record.id);

    if (error != null) {
      onMessage(error, success: false);
    } else {
      onMessage(
        'Registro DNS ${record.fqdn} revocado correctamente.',
        success: true,
      );
    }
  }
}
