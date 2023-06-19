// ignore_for_file: constant_identifier_names

import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/inventory_advanced_search/notifiers.dart';
import 'package:eon_asset_tracker/models/category_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/categories_notifier.dart';
import '../notifiers/departments_notifier.dart';

enum AdvancedSearchStatusEnum {
  All,
  Good,
  Defective,
  Unknown,
}

class SearchPopup extends ConsumerStatefulWidget {
  const SearchPopup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPopupState();
}

class _SearchPopupState extends ConsumerState<SearchPopup> {
  static final TextEditingController itemNameController = TextEditingController();
  static final TextEditingController assetIDController = TextEditingController();
  static final TextEditingController personAccountableController = TextEditingController();

  static AdvancedSearchStatusEnum selectedStatusFilter = AdvancedSearchStatusEnum.All;
  static Department? selectedDepartment;
  static ItemCategory? selectedCategory;

  static List<Department> departments = [];

  @override
  void initState() {
    super.initState();

    List<Department> departmentsBuffer = ref.read(departmentsNotifierProvider).valueOrNull ?? [];

    departments = [Department(departmentID: generateRandomID(), departmentName: 'All Departments'), ...departmentsBuffer];

    selectedDepartment = departments.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.70),
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'S E A R C H   F I L T E R',
                    style: TextStyle(fontSize: 25),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    _assetIDFilter(),
                    _itemNameFilter(),
                    _departmentFilter(),
                    _personAccountableFilter(),
                    _categoryFilter(),
                    _statusFilter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _itemNameFilter() {
    InventorySearchFilter filter = InventorySearchFilter.itemName;
    bool isEnabled = ref.watch(activeSearchFiltersNotifierProvider).contains(filter);

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Filter by Item Name'),
              value: isEnabled,
              onChanged: (newValue) {
                if (newValue) {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).enable(filter);
                } else {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).disable(filter);
                  itemNameController.clear();
                }
              },
            ),
            TextField(
              controller: itemNameController,
              enabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Card _assetIDFilter() {
    InventorySearchFilter filter = InventorySearchFilter.assetID;
    bool isEnabled = ref.watch(activeSearchFiltersNotifierProvider).contains(filter);

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Filter by Asset ID'),
              value: isEnabled,
              onChanged: (newValue) {
                if (newValue) {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).enable(filter);
                } else {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).disable(filter);
                  assetIDController.clear();
                }
              },
            ),
            TextField(
              controller: assetIDController,
              enabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Card _departmentFilter() {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              title: Text('Filter by Department'),
            ),
            _departmentDropdown(),
          ],
        ),
      ),
    );
  }

  Card _statusFilter() {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              title: Text('Filter by Status'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: AdvancedSearchStatusEnum.values.map((e) {
                return ChoiceChip(
                  label: Text(e.name),
                  selected: selectedStatusFilter == e,
                  onSelected: (value) {
                    setState(() {
                      selectedStatusFilter = e;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _departmentDropdown() {
    return DropdownButtonFormField<Department>(
      value: selectedDepartment,
      focusColor: Colors.transparent,
      borderRadius: defaultBorderRadius,
      items: departments.map((e) {
        return DropdownMenuItem<Department>(
          value: e,
          child: Text(e.departmentName),
        );
      }).toList(),
      onChanged: (Department? value) {
        if (value == null) return;

        setState(() {
          selectedDepartment = value;
        });
      },
    );
  }

  Card _personAccountableFilter() {
    InventorySearchFilter filter = InventorySearchFilter.personAccountable;
    bool isEnabled = ref.watch(activeSearchFiltersNotifierProvider).contains(filter);

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Filter by Person Accountable'),
              value: isEnabled,
              onChanged: (newValue) {
                if (newValue) {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).enable(filter);
                } else {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).disable(filter);
                  itemNameController.clear();
                }
              },
            ),
            TextField(
              controller: personAccountableController,
              enabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Card _categoryFilter() {
    InventorySearchFilter filter = InventorySearchFilter.category;
    bool isEnabled = ref.watch(activeSearchFiltersNotifierProvider).contains(filter);

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Filter by Category'),
              value: isEnabled,
              onChanged: (newValue) {
                if (newValue) {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).enable(filter);
                } else {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).disable(filter);
                }
              },
            ),
            _categoryDropdown(isEnabled),
          ],
        ),
      ),
    );
  }

  Widget _categoryDropdown(bool isEnabled) {
    return ref.watch(categoriesNotifierProvider).when(
          data: (List<ItemCategory> categories) {
            selectedCategory = categories.first;

            return DropdownButtonFormField<ItemCategory>(
              value: selectedCategory,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              items: categories.map((e) {
                return DropdownMenuItem<ItemCategory>(
                  value: e,
                  child: Text(e.categoryName),
                );
              }).toList(),
              onChanged: isEnabled
                  ? (ItemCategory? value) {
                      if (value == null) return;

                      selectedCategory = value;
                    }
                  : null,
            );
          },
          error: (e, st) => Center(
            child: Text(e.toString()),
          ),
          loading: () => const Center(
            child: Text('Loading...'),
          ),
        );
  }
}
