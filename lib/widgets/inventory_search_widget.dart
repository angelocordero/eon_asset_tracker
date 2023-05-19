import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';

class InventorySearchWidget extends ConsumerStatefulWidget {
  const InventorySearchWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventorySearchWidgetState();
}

class _InventorySearchWidgetState extends ConsumerState<InventorySearchWidget> {
  Widget _searchField = Container();

  @override
  void initState() {
    _searchField = _queryTextField();

    super.initState();
  }

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
      onPressed: () async {
        await _search();
      },
      child: const Text('Search'),
    );
  }

  Future<void> _search() async {
    InventorySearchFilter filter = ref.read(searchFilterProvider);

    if (filter == InventorySearchFilter.assetID ||
        filter == InventorySearchFilter.itemName ||
        filter == InventorySearchFilter.personAccountable ||
        filter == InventorySearchFilter.unit ||
        filter == InventorySearchFilter.itemDescription ||
        filter == InventorySearchFilter.remarks) {
      ref.read(searchQueryProvider.notifier).state = widget.controller.text.trim();
    }

    ref.read(currentInventoryPage.notifier).state = 0;

    if (ref.read(searchQueryProvider).trim().isEmpty) {
      await ref.read(inventoryProvider.notifier).initUnfilteredInventory();
    } else {
      await ref.read(inventoryProvider.notifier).initFilteredInventory(ref.read(searchQueryProvider).trim(), filter);
    }
  }

  SizedBox _searchByDropdown(WidgetRef ref) {
    return SizedBox(
      width: 200,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<InventorySearchFilter>(
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
          items: InventorySearchFilter.values.map((value) {
            return DropdownMenuItem<InventorySearchFilter>(
              value: value,
              child: Text(
                inventoryFilterEnumToDisplayString(value) ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (InventorySearchFilter? filter) {
            if (filter == null) return;

            if (filter == InventorySearchFilter.assetID ||
                filter == InventorySearchFilter.itemName ||
                filter == InventorySearchFilter.personAccountable ||
                filter == InventorySearchFilter.unit ||
                filter == InventorySearchFilter.itemDescription ||
                filter == InventorySearchFilter.remarks) {
              setState(() {
                _searchField = _queryTextField();
              });
            } else if (filter == InventorySearchFilter.status) {
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
            } else if (filter == InventorySearchFilter.department) {
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
            } else if (filter == InventorySearchFilter.category) {
              List<String> categoryIDs = ref.read(categoriesProvider).map((e) => e.categoryID).toList();

              if (categoryIDs.isNotEmpty) {
                ref.read(searchQueryProvider.notifier).state = categoryIDs.first;
                setState(
                  () {
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
              } else {
                ref.read(searchQueryProvider.notifier).state = 'No Category';
                setState(
                  () {
                    _searchField = _queryDropdownField(
                      [
                        DropdownMenuItem(
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = 'No Category';
                          },
                          value: 'No Category',
                          child: const Text('No Category'),
                        )
                      ],
                    );
                  },
                );
              }
            }

            ref.read(searchFilterProvider.notifier).state = filter;
          },
        ),
      ),
    );
  }

  SizedBox _queryTextField() {
    return SizedBox(
      width: 200,
      child: TextField(
        onSubmitted: (value) {
          _search();
        },
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
