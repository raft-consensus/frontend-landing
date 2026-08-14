// ==========================================
// Qué hace: Orquesta el diálogo modal para crear o editar un registro DNS en Cloudflare.
// Dónde se conecta: Invocado desde DnsToolbar o DnsTable en DnsSslPage.
// De dónde recibe datos: Recibe BuildContext, WidgetRef, DnsRecord opcional y callback onMessage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_dns_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/dns/create_edit_dns_dialog.dart';

/// Acción encargada del aprovisionamiento y edición de registros DNS
abstract class DnsCreateOrEditAction {
  /// Despliega el modal y ejecuta la operación en el proveedor
  static Future<void> execute({
    required BuildContext context, // Contexto visual
    required WidgetRef ref, // Referencia Riverpod
    required void Function(String message, {bool success}) onMessage, // Notificador
    DnsRecord? recordToEdit, // Registro a modificar (null para creación)
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CreateEditDnsDialog(initialRecord: recordToEdit),
    );

    if (result == null) return;

    final sub = result['subdomain'] as String;
    final ip = result['targetIp'] as String;
    final comm = result['comment'] as String?;

    if (recordToEdit != null) {
      // Flujo de Edición
      final error = await ref.read(userDnsProvider.notifier).updateRecord(
            id: recordToEdit.id,
            subdomain: sub,
            targetIp: ip,
            comment: comm,
          );

      if (error != null) {
        onMessage(error, success: false);
      } else {
        onMessage(
          'Subdominio $sub.coderhivex.com actualizado correctamente.',
          success: true,
        );
      }
    } else {
      // Flujo de Creación
      final error = await ref.read(userDnsProvider.notifier).addRecord(
            subdomain: sub,
            targetIp: ip,
            comment: comm,
          );

      if (error != null) {
        onMessage(error, success: false);
      } else {
        onMessage(
          'Subdominio $sub.coderhivex.com aprovisionado correctamente en Cloudflare.',
          success: true,
        );
      }
    }
  }
}
