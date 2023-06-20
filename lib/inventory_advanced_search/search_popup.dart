// ignore_for_file: constant_identifier_names

import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/inventory_advanced_search/advanced_inventory_notifier.dart';
import 'package:eon_asset_tracker/inventory_advanced_search/notifiers.dart';
import 'package:eon_asset_tracker/models/category_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:eon_asset_tracker/widgets/search_daterange_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
  static late TextEditingController itemNameController;
  static late TextEditingController assetIDController;
  static late TextEditingController personAccountableController;
  static late TextEditingController unitController;
  static late TextEditingController fromPriceController;
  static late TextEditingController toPriceController;

  static late AdvancedSearchStatusEnum selectedStatusFilter;
  static Department? selectedDepartment;
  static ItemCategory? selectedCategory;

  static List<Department> departments = [];

  static late FocusNode fromFocusNode;
  static late FocusNode toFocusNode;

  static late DateTimeRange purchaseRange;
  static late DateTimeRange receiveRange;

  @override
  void initState() {
    super.initState();

    purchaseRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    receiveRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

    fromFocusNode = FocusNode();
    toFocusNode = FocusNode();

    itemNameController = TextEditingController();
    assetIDController = TextEditingController();
    personAccountableController = TextEditingController();
    unitController = TextEditingController();
    toPriceController = TextEditingController();
    fromPriceController = TextEditingController();

    selectedStatusFilter = AdvancedSearchStatusEnum.All;

    List<Department> departmentsBuffer = ref.read(departmentsNotifierProvider).valueOrNull ?? [];

    departments = [Department(departmentID: 'hotdog', departmentName: 'All Departments'), ...departmentsBuffer];

    selectedDepartment = departments.first;

    fromFocusNode.addListener(
      () {
        if (fromFocusNode.hasFocus) return;

        if (fromPriceController.text.trim().isEmpty) return;

        double from = double.tryParse(fromPriceController.text.trim()) ?? 0;
        double to = double.tryParse(toPriceController.text.trim()) ?? 0;

        if (to >= from) return;

        toPriceController.value = fromPriceController.value;
      },
    );

    toFocusNode.addListener(
      () {
        if (toFocusNode.hasFocus) return;

        if (fromPriceController.text.trim().isEmpty) return;

        double from = double.tryParse(fromPriceController.text.trim()) ?? 0;
        double to = double.tryParse(toPriceController.text.trim()) ?? 0;

        if (to >= from) return;

        toPriceController.value = fromPriceController.value;
      },
    );
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'A D V A N C E D   S E A R C H   F I L T E R',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _reset();
                          },
                          child: const Text('Reset'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> searchData = {};

                            ref.read(activeSearchFiltersNotifierProvider).forEach((InventorySearchFilter element) {
                              String columnString = inventoryFilterEnumToDatabaseString(element);

                              switch (element) {
                                case InventorySearchFilter.datePurchased:
                                  String from = dateTimeToSQLString(purchaseRange.start);
                                  String to = dateTimeToSQLString(purchaseRange.end);

                                  searchData[columnString] = (from, to);

                                  break;
                                case InventorySearchFilter.dateReceived:
                                  String from = dateTimeToSQLString(receiveRange.start);
                                  String to = dateTimeToSQLString(receiveRange.end);

                                  searchData[columnString] = (from, to);

                                  break;
                                case InventorySearchFilter.price:
                                  String from = fromPriceController.text.trim();
                                  String to = toPriceController.text.trim();

                                  searchData[columnString] = (from, to);
                                  break;

                                case InventorySearchFilter.assetID:
                                  searchData[columnString] = assetIDController.text.trim();
                                  break;

                                case InventorySearchFilter.itemName:
                                  searchData[columnString] = itemNameController.text.trim();
                                  break;

                                case InventorySearchFilter.personAccountable:
                                  searchData[columnString] = personAccountableController.text.trim();
                                  break;

                                case InventorySearchFilter.unit:
                                  searchData[columnString] = unitController.text.trim();
                                  break;

                                case InventorySearchFilter.status:
                                  searchData[columnString] = selectedStatusFilter;
                                  break;

                                case InventorySearchFilter.department:
                                  if (selectedDepartment == null) break;
                                  searchData[columnString] = selectedDepartment!.departmentID;
                                  break;

                                case InventorySearchFilter.category:
                                  if (selectedCategory == null) break;
                                  searchData[columnString] = selectedCategory!.categoryID;
                                  break;

                                default:
                              }
                            });

                            ref.read(advancedSearchDataNotifierProvider.notifier).setState(searchData);

                            ref.read(isAdvancedFilterNotifierProvider.notifier).activate();

                            await ref.read(advancedInventoryNotifierProvider.notifier).getInventory();

                            // await ref.read(inventoryNotifierProvider.notifier).getAdvancedFilteredInvetory();

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                          child: const Text('Search'),
                        ),
                      ],
                    ),
                    _assetIDFilter(),
                    _itemNameFilter(),
                    _departmentFilter(),
                    _personAccountableFilter(),
                    _categoryFilter(),
                    _statusFilter(),
                    _unitFilter(),
                    _priceFilter(),
                    _datePurchasedFilter(),
                    _dateReceivedFilter(),
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
                  personAccountableController.clear();
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

            return Autocomplete<ItemCategory>(
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                focusNode.addListener(() {
                  if (!focusNode.hasFocus) {
                    // checks if the current text in the controller is a category name
                    // if true, returns that category,
                    // if false, returns last category that was matched
                    ItemCategory? buffer = categories.singleWhere((element) => element.categoryName == textEditingController.text.trim(),
                        orElse: () => selectedCategory!);

                    textEditingController.text = buffer.categoryName;
                  }
                });

                return TextFormField(
                  enabled: isEnabled,
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
              initialValue: TextEditingValue(text: selectedCategory!.categoryName),
              optionsBuilder: (TextEditingValue option) {
                return categories.where((element) => element.categoryName.toLowerCase().contains(option.text.toLowerCase().trim()));
              },
              displayStringForOption: (option) => option.categoryName,
              onSelected: (option) => selectedCategory = option,
              optionsViewBuilder: (context, onSelected, options) {
                /// sets the max number of displayed options in dropdown
                int maxOptionsInView = options.length >= 5 ? 5 : options.length;

                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
                    ),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.25, // <-- Right here !
                      height: 50 * maxOptionsInView.toDouble(),
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          ItemCategory category = options.elementAt(index);

                          return InkWell(
                            onTap: () {
                              onSelected(category);
                            },
                            child: Builder(
                              builder: (BuildContext context) {
                                final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                                if (highlight) {
                                  SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                                    Scrollable.ensureVisible(context, alignment: 0.5);
                                  });
                                }
                                return Container(
                                  color: highlight ? Theme.of(context).focusColor : null,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(category.categoryName),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
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

  Card _unitFilter() {
    InventorySearchFilter filter = InventorySearchFilter.unit;
    bool isEnabled = ref.watch(activeSearchFiltersNotifierProvider).contains(filter);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Filter by Unit'),
              value: isEnabled,
              onChanged: (newValue) {
                if (newValue) {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).enable(filter);
                } else {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).disable(filter);
                  unitController.clear();
                }
              },
            ),
            TextField(
              controller: unitController,
              enabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Card _datePurchasedFilter() {
    InventorySearchFilter filter = InventorySearchFilter.datePurchased;
    bool isEnabled = ref.watch(activeSearchFiltersNotifierProvider).contains(filter);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Filter by Purchase Data'),
              value: isEnabled,
              onChanged: (newValue) {
                if (newValue) {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).enable(filter);
                } else {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).disable(filter);
                }
              },
            ),
            SearchDaterangePicker(
              callback: (range) {
                purchaseRange = range;
              },
              enabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Card _dateReceivedFilter() {
    InventorySearchFilter filter = InventorySearchFilter.dateReceived;
    bool isEnabled = ref.watch(activeSearchFiltersNotifierProvider).contains(filter);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Filter by Receive Data'),
              value: isEnabled,
              onChanged: (newValue) {
                if (newValue) {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).enable(filter);
                } else {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).disable(filter);
                }
              },
            ),
            SearchDaterangePicker(
              callback: (range) {
                receiveRange = range;
              },
              enabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Card _priceFilter() {
    InventorySearchFilter filter = InventorySearchFilter.price;
    bool isEnabled = ref.watch(activeSearchFiltersNotifierProvider).contains(filter);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Filter by Price'),
              value: isEnabled,
              onChanged: (newValue) {
                if (newValue) {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).enable(filter);
                } else {
                  ref.read(activeSearchFiltersNotifierProvider.notifier).disable(filter);
                  toPriceController.clear();
                  fromPriceController.clear();
                }
              },
            ),
            Row(
              children: [
                const Text('From: '),
                const SizedBox(width: 20),
                SizedBox(
                  width: 150,
                  child: TextField(
                    enabled: isEnabled,
                    focusNode: fromFocusNode,
                    controller: fromPriceController,
                    inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true)],
                    decoration: const InputDecoration(
                      icon: Text(
                        '₱',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                const Text('To: '),
                const SizedBox(width: 20),
                SizedBox(
                  width: 150,
                  child: TextField(
                    enabled: isEnabled,
                    focusNode: toFocusNode,
                    controller: toPriceController,
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true),
                    ],
                    decoration: const InputDecoration(
                      icon: Text(
                        '₱',
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    itemNameController.dispose();
    assetIDController.dispose();
    personAccountableController.dispose();
    unitController.dispose();
    toPriceController.dispose();
    fromPriceController.dispose();

    fromFocusNode.dispose();
    toFocusNode.dispose();

    super.dispose();
  }

  void _reset() {
    purchaseRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    receiveRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

    itemNameController.clear();
    assetIDController.clear();
    personAccountableController.clear();
    unitController.clear();
    toPriceController.clear();
    fromPriceController.clear();

    selectedStatusFilter = AdvancedSearchStatusEnum.All;

    selectedDepartment = departments.first;

    ref.invalidate(activeSearchFiltersNotifierProvider);
    ref.invalidate(advancedSearchDataNotifierProvider);
    ref.invalidate(isAdvancedFilterNotifierProvider);
  }
}
