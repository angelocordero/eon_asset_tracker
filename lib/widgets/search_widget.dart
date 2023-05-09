import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import '../core/constants.dart';

class SearchWidget extends ConsumerWidget {
  const SearchWidget({super.key, required this.controller});

  final TextEditingController controller;

  static final List<String> _searchByList = [
    'Asset ID',
    'Item Name',
    'Person Accountable',
    'Unit',
    'Item Description',
    'Remarks',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: 20,
              ),
              isDense: true,
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 200,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              iconSize: 12,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                labelText: 'Search By',
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: ref.watch(searchQueryProvider),
              items: _searchByList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? input) {
                if (input == null) return;

                ref.read(searchQueryProvider.notifier).state = input;
              },
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MySqlConnection? conn = ref.read(sqlConnProvider);
            String searchBy = ref.read(searchQueryProvider);
            ref.read(inventoryProvider.notifier).search(
                  conn: conn,
                  query: controller.text.trim(),
                  searchBy: searchBy,
                );
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
}
