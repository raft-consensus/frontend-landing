import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/admin/domain/entities/platform_user.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_scroll_view.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/section_title.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/filter_bar.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/empty_state.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/users/user_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/dialogs/user_details_dialog.dart'; // Widget

class UsersPage extends StatefulWidget {
  const UsersPage({
    required this.users,
    required this.onToggle,
    required this.onDelete,
    required this.onMessage,
    super.key,
  });

  final List<PlatformUser> users;
  final ValueChanged<PlatformUser> onToggle;
  final ValueChanged<PlatformUser> onDelete;
  final void Function(String, {bool success}) onMessage;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _query = '';
  String _status = 'Todos';

  List<PlatformUser> get filteredUsers {
    return widget.users.where((user) {
      final query = _query.toLowerCase();

      final matchesQuery =
          user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query);

      final matchesStatus = _status == 'Todos' ||
          (_status == 'Activos' && !user.suspended) ||
          (_status == 'Suspendidos' && user.suspended);

      return matchesQuery && matchesStatus;
    }).toList();
  }

  void _showUser(PlatformUser user) {
    showDialog(
      context: context,
      builder: (context) => UserDetailsDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Gestión de usuarios',
            subtitle:
                'Administra las cuentas y los accesos a la plataforma.',
            action: 'Invitar usuario',
            actionIcon: Icons.person_add_alt_1_rounded,
            onAction: () => widget.onMessage(
              'Abriendo invitación de usuario...',
            ),
          ),
          const SizedBox(height: 20),
          FilterBar(
            hint: 'Buscar por nombre o correo...',
            selectedFilter: _status,
            filters: const ['Todos', 'Activos', 'Suspendidos'],
            onSearch: (value) => setState(() => _query = value),
            onFilter: (value) => setState(() => _status = value),
          ),
          const SizedBox(height: 18),
          if (filteredUsers.isEmpty)
            const EmptyState(
              icon: Icons.person_search_rounded,
              title: 'No encontramos usuarios',
              description: 'Prueba con otro término o filtro.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth >= 900
                    ? (constraints.maxWidth - 18) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: filteredUsers
                      .map(
                        (user) => UserCard(
                          width: cardWidth,
                          user: user,
                          onDetails: () => _showUser(user),
                          onToggle: () => widget.onToggle(user),
                          onDelete: () => widget.onDelete(user),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
