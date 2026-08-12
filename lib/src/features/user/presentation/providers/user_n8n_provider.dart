import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/core/network/session_storage.dart';
import 'package:frontend_landing/src/features/user/data/datasources/n8n_remote_datasource.dart';
import 'package:frontend_landing/src/features/user/domain/entities/n8n_service_data.dart';

/// ¿Qué hace?: Provider global para instanciar la fuente de datos remota de n8n inyectando ApiClient y SessionStorage.
/// ¿De dónde trae datos?: Inyecta las instancias de ApiClient y SessionStorage (para leer el JWT de autenticación).
/// ¿Hacia dónde va / Cómo se conecta?: Se consume internamente dentro de UserN8nNotifier.
final n8nRemoteDataSourceProvider = Provider<N8nRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final sessionStorage = ref.watch(sessionStorageProvider);
  return N8nRemoteDataSource(apiClient, sessionStorage);
});

/// ¿Qué hace?: Gestor de estado que consulta el backend C# y mantiene el estado real devuelto desde SQL Server.
/// ¿De dónde trae datos?: Consume N8nRemoteDataSource obteniendo la credencial directa persistida en SQL Server.
/// ¿Hacia dónde va / Cómo se conecta?: Proporciona estado a N8nServicesPage y maneja la apertura de enlaces personales.
class UserN8nNotifier extends StateNotifier<N8nServiceData?> {
  final N8nRemoteDataSource _dataSource; // DataSource remoto inyectado

  UserN8nNotifier(this._dataSource) : super(null) {
    loadN8nData(); // Carga inicial al instanciar
  }

  /// Carga la información de la cuenta n8n desde el backend C# asignando la credencial persistida en SQL Server
  Future<void> loadN8nData() async {
    try {
      final accounts = await _dataSource.getMyAccounts();
      if (accounts.isNotEmpty) {
        final activeAccount = accounts.firstWhere(
          (acc) => acc.status.toLowerCase() == 'active',
          orElse: () => accounts.first,
        );

        // Lee la credencial persistida en SQL Server (si no existe, se asigna string vacío '')
        final studioUrl = activeAccount.credential ?? '';

        state = N8nServiceData(
          isActivated: activeAccount.status.toLowerCase() == 'active',
          accountId: activeAccount.accountId ?? 'n8n_${activeAccount.id}',
          serviceStatus: activeAccount.status.toUpperCase(),
          studioUrl: studioUrl, // URL devuelta directamente por la base de datos SQL Server
          apiKey: activeAccount.credential ?? '',
          webhookBaseUrl: 'https://n8n.raft.andrescortes.dev/webhook/',
          activeWorkflows: activeAccount.activeWorkflowsCount,
          maxWorkflows: activeAccount.maxWorkflowsCount,
          monthlyExecutions: activeAccount.monthlyExecutions,
          maxMonthlyExecutions: activeAccount.maxMonthlyExecutions,
          workflows: [],
        );
      } else {
        // Estado inactivo sin URL previa si no hay cuenta registrada
        state = const N8nServiceData(
          isActivated: false,
          serviceStatus: 'INACTIVE',
          studioUrl: '',
          apiKey: '',
          webhookBaseUrl: 'https://n8n.raft.andrescortes.dev/webhook/',
          activeWorkflows: 0,
          maxWorkflows: 5,
          monthlyExecutions: 0,
          maxMonthlyExecutions: 1000,
          workflows: [],
        );
      }
    } catch (e) {
      state = const N8nServiceData(
        isActivated: false,
        serviceStatus: 'INACTIVE',
        studioUrl: '',
        apiKey: '',
        webhookBaseUrl: 'https://n8n.raft.andrescortes.dev/webhook/',
        activeWorkflows: 0,
        maxWorkflows: 5,
        monthlyExecutions: 0,
        maxMonthlyExecutions: 1000,
        workflows: [],
      );
    }
  }

  /// Dispara la petición POST /api/me/n8n/provision y abre el link de registro o acceso en el navegador
  Future<bool> provisionAccount() async {
    try {
      final result = await _dataSource.provisionAccount();
      
      final isActivated = result.account.status.toLowerCase() == 'active' || result.account.status.toLowerCase() == 'pending';
      final studioUrl = result.credential ?? result.account.credential ?? '';

      state = N8nServiceData(
        isActivated: isActivated,
        accountId: result.account.accountId ?? 'n8n_${result.account.id}',
        serviceStatus: result.account.status.toUpperCase(),
        studioUrl: studioUrl,
        apiKey: studioUrl,
        webhookBaseUrl: 'https://n8n.raft.andrescortes.dev/webhook/',
        activeWorkflows: result.account.activeWorkflowsCount,
        maxWorkflows: result.account.maxWorkflowsCount,
        monthlyExecutions: result.account.monthlyExecutions,
        maxMonthlyExecutions: result.account.maxMonthlyExecutions,
        workflows: state?.workflows ?? [],
      );

      // Si el backend retornó una URL válida de acceso, se abre en el navegador
      if (studioUrl.startsWith('http')) {
        final uri = Uri.parse(studioUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Alterna el estado activo de un flujo en memoria
  void toggleWorkflowStatus(String workflowId) {
    if (state == null) return;
    final updatedList = state!.workflows.map((wf) {
      if (wf.id == workflowId) {
        return wf.copyWith(isActive: !wf.isActive);
      }
      return wf;
    }).toList();

    state = state!.copyWith(
      workflows: updatedList,
      activeWorkflows: updatedList.where((w) => w.isActive).length,
    );
  }
}

/// Provider público de Riverpod
final userN8nProvider = StateNotifierProvider<UserN8nNotifier, N8nServiceData?>((ref) {
  final dataSource = ref.watch(n8nRemoteDataSourceProvider);
  return UserN8nNotifier(dataSource);
});
