// Flutter imports:
import 'package:eon_asset_tracker/models/category_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:eon_asset_tracker/widgets/search_daterange_picker.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/constants.dart';
import '../core/providers.dart';
import '../core/utils.dart';

class InventorySearchWidget extends ConsumerStatefulWidget {
  const InventorySearchWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventorySearchWidgetState();
}

class _InventorySearchWidgetState extends ConsumerState<InventorySearchWidget> {
  Widget _searchField = Container();

  DateTimeRange range = DateTimeRange(start: DateTime.now().toUtc(), end: DateTime.now().toUtc());

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
    } else if (filter == InventorySearchFilter.datePurchased || filter == InventorySearchFilter.dateReceived) {
      ref.read(searchQueryProvider.notifier).state = range;
    }

    ref.read(currentInventoryPage.notifier).state = 0;

    // if (filter == InventorySearchFilter.datePurchased || filter == InventorySearchFilter.dateReceived) {
    //   EasyLoading.showInfo('Sir wala pa ni natapos');
    // }

    dynamic query = ref.read(searchQueryProvider);
    if (query is DateTimeRange) {
      await ref.read(inventoryProvider.notifier).initFilteredInventory(query, filter);
    } else if (query.trim().isEmpty) {
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
              List<Department> departments = [
                ...ref.read(departmentsProvider),
                Department(
                  departmentID: 'null',
                  departmentName: 'No Category',
                ),
              ];

              ref.read(searchQueryProvider.notifier).state = departments.first.departmentID;
              setState(
                () {
                  _searchField = _queryDropdownField(
                    departments.map(
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
              List<ItemCategory> categories = [
                ...ref.read(categoriesProvider),
                ItemCategory(
                  categoryID: 'null',
                  categoryName: 'No Category',
                ),
              ];

              ref.read(searchQueryProvider.notifier).state = categories.first.categoryID!;
              setState(
                () {
                  _searchField = _queryDropdownField(
                    categories.map(
                      (e) {
                        return DropdownMenuItem(
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = e.categoryID!;
                          },
                          value: e.categoryID,
                          child: Text(e.categoryName),
                        );
                      },
                    ).toList(),
                  );
                },
              );
            } else if (filter == InventorySearchFilter.datePurchased || filter == InventorySearchFilter.dateReceived) {
              setState(
                () {
                  _searchField = SearchDaterangePicker(
                    callback: (DateTimeRange newRange) {
                      range = newRange;
                    },
                  );
                },
              );
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
