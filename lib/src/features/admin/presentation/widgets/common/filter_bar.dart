import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget


class FilterBar extends StatelessWidget {
  const FilterBar({
    required this.hint,
    required this.selectedFilter,
    required this.filters,
    required this.onSearch,
    required this.onFilter,
    super.key,
  });

  final String hint;
  final String selectedFilter;
  final List<String> filters;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;

          final search = TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          );

          final filter = DropdownButtonFormField<String>(
            initialValue: selectedFilter,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.filter_list_rounded),
            ),
            items: filters
                .map(
                  (filter) => DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onFilter(value);
            },
          );

          if (compact) {
            return Column(
              children: [
                search,
                const SizedBox(height: 12),
                filter,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: search),
              const SizedBox(width: 13),
              SizedBox(width: 210, child: filter),
            ],
          );
        },
      ),
    );
  }
}
