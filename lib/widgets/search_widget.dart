import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  Widget _searchField = Container();

  @override
  void initState() {
    _searchField = _queryTextField();

    super.initState();
  }

  static final List<String> _searchByList = [
    'Asset ID',
    'Item Name',
    'Person Accountable',
    'Unit',
    'Item Description',
    'Remarks',
    'Status',
    'Department',
    'Category',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _searchByDropdown(ref),
        const SizedBox(
          width: 20,
        ),
        _searchField,
        const SizedBox(
          width: 20,
        ),
        _searchButton(ref),
      ],
    );
  }

  ElevatedButton _searchButton(WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        String input = ref.read(searchFilterProvider);

        if (input == 'Asset ID' || input == 'Item Name' || input == 'Person Accountable' || input == 'Unit' || input == 'Item Description' || input == 'Remarks') {
          ref.read(searchQueryProvider.notifier).state = widget.controller.text.trim();
        }

        ref.read(currentInventoryPage.notifier).state = 0;
        ref.read(inventoryProvider.notifier).getItems(0);
      },
      child: const Text('Search'),
    );
  }

  SizedBox _searchByDropdown(WidgetRef ref) {
    return SizedBox(
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
          value: ref.watch(searchFilterProvider),
          items: _searchByList.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (String? input) {
            if (input == null) return;

            if (input == 'Asset ID' || input == 'Item Name' || input == 'Person Accountable' || input == 'Unit' || input == 'Item Description' || input == 'Remarks') {
              setState(() {
                _searchField = _queryTextField();
              });
            } else if (input == 'Status') {
              setState(
                () {
                  ref.read(searchQueryProvider.notifier).state = ItemStatus.values.first.name;
                  _searchField = _queryDropdownField(
                    ItemStatus.values.map(
                      (e) {
                        return DropdownMenuItem(
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = e.name;
                          },
                          value: e.name,
                          child: Text(e.name),
                        );
                      },
                    ).toList(),
                  );
                },
              );
            } else if (input == 'Department') {
              setState(
                () {
                  ref.read(searchQueryProvider.notifier).state = ref.read(departmentsProvider).first.departmentID;
                  _searchField = _queryDropdownField(
                    ref.read(departmentsProvider).map(
                      (e) {
                        return DropdownMenuItem(
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = e.departmentID;
                          },
                          value: e.departmentID,
                          child: Text(e.departmentName),
                        );
                      },
                    ).toList(),
                  );
                },
              );
            } else if (input == 'Category') {
              setState(
                () {
                  ref.read(searchQueryProvider.notifier).state = ref.read(categoriesProvider).first.categoryID;
                  _searchField = _queryDropdownField(
                    ref.read(categoriesProvider).map(
                      (e) {
                        return DropdownMenuItem(
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = e.categoryID;
                          },
                          value: e.categoryID,
                          child: Text(e.categoryName),
                        );
                      },
                    ).toList(),
                  );
                },
              );
            }

            ref.read(searchFilterProvider.notifier).state = input;
          },
        ),
      ),
    );
  }

  SizedBox _queryTextField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: widget.controller,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 20,
          ),
          isDense: true,
          contentPadding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  SizedBox _queryDropdownField(List<DropdownMenuItem<String>> items) {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField(
        value: ref.watch(searchQueryProvider),
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
        items: items,
        onChanged: (value) {
          if (value == null) return;

          ref.read(searchQueryProvider.notifier).state = value;
        },
      ),
    );
  }
}
