// ==========================================
// Qué hace: Vista principal del Servicio de IA para administrar API Keys conectándose con la API real C#.
// Dónde se conecta: Se incluye en el IndexedStack de DashboardPage (índice 3).
// De dónde trae datos: Escucha userAiProvider usando Riverpod y delega acciones a AiKeyActionsHelper.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart'; // Riverpod Provider
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_info_card.dart'; // Componente informativo
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_actions_helper.dart'; // Helper de acciones desacoplado
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_keys_table.dart'; // Tabla de claves
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_summary_cards.dart'; // Tarjetas resumen KPI
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_toolbar.dart'; // Barra de búsqueda
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart'; // Contenedor Scroll
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart'; // Encabezado de sección

/// Vista principal de administración del Servicio de IA
class AiServicesPage extends ConsumerStatefulWidget {
  const AiServicesPage({required this.onMessage, super.key});

  final void Function(String message, {bool success})
  onMessage; // Callback para emitir notificaciones

  @override
  ConsumerState<AiServicesPage> createState() => _AiServicesPageState();
}

class _AiServicesPageState extends ConsumerState<AiServicesPage> {
  String _searchQuery =
      ''; // Cadena de búsqueda para filtrar la tabla de claves
  AiKeyFilter _statusFilter = AiKeyFilter.active;

  @override
  Widget build(BuildContext context) {
    final allKeys = ref.watch(
      userAiProvider,
    ); // Obtiene el estado actual de claves
    final activeKeysCount = allKeys
        .where((k) => k.isActive)
        .length; // Conteo de claves activas
    final totalRequests = allKeys.fold<int>(
      0,
      (sum, k) => sum + k.totalRequests,
    ); // Suma total de peticiones
    final totalTokens = allKeys.fold<int>(
      0,
      (sum, k) => sum + k.totalTokens,
    ); // Suma total de tokens

    // Filtra las API Keys en tiempo real según la búsqueda ingresada
    final filteredKeys = allKeys.where((k) {
      // 1. Aplica el filtro por estado (Activas por defecto)
      if (_statusFilter == AiKeyFilter.active && !k.isActive) return false;
      if (_statusFilter == AiKeyFilter.revoked && k.isActive) return false;
      // 2. Aplica el filtro de texto por búsqueda
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase().trim();
      return k.name.toLowerCase().contains(q) ||
          k.keyPrefix.toLowerCase().contains(q);
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Encabezado de la página
          const SectionHeader(
            title: 'Servicios de Inteligencia Artificial',
            subtitle:
                'Administra tus API Keys para consumir los servicios de IA de Raft',
          ),
          const SizedBox(height: 20),

          // 2. Tarjetas KPI superiores
          AiSummaryCards(
            activeKeysCount: activeKeysCount,
            totalRequests: totalRequests,
            totalTokens: totalTokens,
          ),
          const SizedBox(height: 24),

          // 3. Barra de herramientas con buscador
          AiToolbar(
            keyCount: allKeys.length,
            selectedFilter: _statusFilter,
            onFilterChanged: (f) => setState(() => _statusFilter = f),
            onSearchChanged: (q) => setState(() => _searchQuery = q),
            onCreateNew: () => AiKeyActionsHelper.openCreateDialog(
              context: context,
              ref: ref,
              onMessage: widget.onMessage,
            ),
          ),
          const SizedBox(height: 16),

          // 4. Tabla de API Keys filtrada delegando rotación y revocación al helper
          AiKeysTable(
            keys: filteredKeys,
            onRotate: (key) => AiKeyActionsHelper.confirmAndRotate(
              context: context,
              ref: ref,
              key: key,
              onMessage: widget.onMessage,
            ),
            onDelete: (key) => AiKeyActionsHelper.confirmAndRevoke(
              context: context,
              ref: ref,
              key: key,
              onMessage: widget.onMessage,
            ),
            onMessage: widget.onMessage,
          ),
          const SizedBox(height: 24),

          // 5. Tarjeta informativa al pie
          const AiInfoCard(),
        ],
      ),
    );
  }
}
