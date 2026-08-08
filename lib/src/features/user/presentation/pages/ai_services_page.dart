import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_info_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_keys_table.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_summary_cards.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_toolbar.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/ai/create_ai_key_dialog.dart';

/// ¿Qué hace?: Vista principal del Servicio de IA para administrar API Keys con búsqueda y medidor de consumo.
/// ¿De dónde trae datos?: Escucha userAiProvider usando Riverpod.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en el IndexedStack de DashboardPage (índice 3).
class AiServicesPage extends ConsumerStatefulWidget {
  const AiServicesPage({required this.onMessage, super.key});

  final void Function(String message, {bool success}) onMessage;

  @override
  ConsumerState<AiServicesPage> createState() => _AiServicesPageState();
}

class _AiServicesPageState extends ConsumerState<AiServicesPage> {
  String _searchQuery = ''; // Cadena de búsqueda en tiempo real

  /// Abre el diálogo modal para crear una nueva clave
  Future<void> _openCreateDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateAiKeyDialog(),
    );

    if (result != null && result.containsKey('name')) {
      final name = result['name'] as String;
      final error = await ref.read(userAiProvider.notifier).addKey(name: name);
      widget.onMessage(
        error ?? 'API Key "$name" generada correctamente.',
        success: error == null,
      );
    }
  }

  /// Pide confirmación antes de revocar la clave
  Future<void> _confirmAndDelete(AiKey key) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Revocar API Key',
      message: '¿Estás seguro de que deseas revocar la clave "${key.name}"? Esta acción no se puede deshacer.',
      confirmLabel: 'Sí, revocar clave',
      icon: Icons.delete_forever_rounded,
    );

    if (confirmed) {
      final error = await ref.read(userAiProvider.notifier).deleteKey(key.id);
      widget.onMessage(
        error ?? 'API Key "${key.name}" revocada correctamente.',
        success: error == null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allKeys = ref.watch(userAiProvider);
    final totalRequests = allKeys.fold<int>(0, (sum, k) => sum + k.requestsUsed);

    // Filtra las API Keys en tiempo real según la búsqueda
    final filteredKeys = allKeys.where((k) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase().trim();
      return k.name.toLowerCase().contains(q) || k.apiKey.toLowerCase().contains(q);
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Encabezado de la página
          const SectionHeader(
            title: 'Servicios de Inteligencia Artificial',
            subtitle: 'Administra tus API Keys para consumir los servicios de IA de Raft',
          ),
          const SizedBox(height: 20),

          // 2. Tarjetas KPI superiores
          AiSummaryCards(totalKeys: allKeys.length, totalRequests: totalRequests),
          const SizedBox(height: 24),

          // 3. Barra de herramientas con buscador y cuota
          AiToolbar(
            keyCount: allKeys.length,
            onSearchChanged: (q) => setState(() => _searchQuery = q),
            onCreateNew: _openCreateDialog,
          ),
          const SizedBox(height: 16),

          // 4. Tabla de API Keys filtrada
          AiKeysTable(keys: filteredKeys, onDelete: _confirmAndDelete, onMessage: widget.onMessage),
          const SizedBox(height: 24),

          // 5. Tarjeta informativa al pie
          const AiInfoCard(),
        ],
      ),
    );
  }
}
