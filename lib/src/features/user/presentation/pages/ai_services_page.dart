// ==========================================
// Que hace: Vista principal del Servicio de IA sin encabezados redundantes.
// De donde trae datos: Escucha userAiProvider usando Riverpod.
// Donde se conecta: Renderizado en el indice 2 del IndexedStack en DashboardPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/actions/ai_key_create_action.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/actions/ai_key_revoke_action.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/actions/ai_key_rotate_action.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/info/ai_info_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/keys/ai_keys_table.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/summary/ai_summary_cards.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/toolbar/ai_toolbar.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';

/// Vista principal de administracion del Servicio de IA
class AiServicesPage extends ConsumerStatefulWidget {
  const AiServicesPage({required this.onMessage, super.key});

  final void Function(String message, {bool success}) onMessage; // Callback para emitir notificaciones

  @override
  ConsumerState<AiServicesPage> createState() => _AiServicesPageState();
}

class _AiServicesPageState extends ConsumerState<AiServicesPage> {
  String _searchQuery = ''; // Cadena de busqueda para filtrar la tabla de claves

  @override
  Widget build(BuildContext context) {
    final allKeys = ref.watch(userAiProvider); // Obtiene el estado actual de claves
    
    // Filtra exclusivamente las claves activas
    final activeKeys = allKeys.where((k) => k.isActive).toList();
    final activeKeysCount = activeKeys.length;
    final totalRequests = activeKeys.fold<int>(0, (sum, k) => sum + k.totalRequests);
    final totalTokens = activeKeys.fold<int>(0, (sum, k) => sum + k.totalTokens);

    // Filtra las API Keys activas segun el buscador
    final filteredKeys = activeKeys.where((k) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase().trim();
      return k.name.toLowerCase().contains(q) || k.keyPrefix.toLowerCase().contains(q);
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tarjetas KPI superiores directas
          AiSummaryCards(
            activeKeysCount: activeKeysCount,
            totalRequests: totalRequests,
            totalTokens: totalTokens,
          ),
          const SizedBox(height: 24),

          // 2. Barra de herramientas con buscador y boton generar
          AiToolbar(
            onSearchChanged: (q) => setState(() => _searchQuery = q),
            onCreateNew: () => AiKeyCreateAction.execute(
              context: context,
              ref: ref,
              onMessage: widget.onMessage,
            ),
          ),
          const SizedBox(height: 16),

          // 3. Tabla de API Keys
          AiKeysTable(
            keys: filteredKeys,
            onRotate: (key) => AiKeyRotateAction.execute(
              context: context,
              ref: ref,
              key: key,
              onMessage: widget.onMessage,
            ),
            onDelete: (key) => AiKeyRevokeAction.execute(
              context: context,
              ref: ref,
              key: key,
              onMessage: widget.onMessage,
            ),
            onMessage: widget.onMessage,
          ),
          const SizedBox(height: 24),

          // 4. Tarjeta informativa al pie
          const AiInfoCard(),
        ],
      ),
    );
  }
}
