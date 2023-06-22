import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/database_api.dart';
import '../core/utils.dart';
import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/item_model.dart';
import '../models/property_model.dart';
import '../notifiers/categories_notifier.dart';
import '../notifiers/departments_notifier.dart';
import '../notifiers/properties_notifier.dart';
import '../notifiers/theme_notifier.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  late List<Department> _departments;
  late List<ItemCategory> _categories;
  late List<Property> _properties;

  late DateTime _datePurchased;
  late DateTime _dateReceived;

  final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 365 * 10));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 10));

  late ItemStatus _itemStatus;
  late Department _department;
  late ItemCategory _category;
  late Property _property;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _personAccountableController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _itemDescriptionController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _countController = TextEditingController(text: '1');

  bool _isPurchased = false;

  @override
  void initState() {
    _datePurchased = DateTime.now();
    _dateReceived = DateTime.now();

    _departments = ref.read(departmentsNotifierProvider).requireValue;
    _categories = ref.read(categoriesNotifierProvider).requireValue;
    _properties = ref.read(propertiesNotifierProvider).requireValue;

    _department = _departments.first;
    _category = _categories.first;
    _property = _properties.first;

    _itemStatus = ItemStatus.Unknown;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              const Text(
                'A D D   I T E M',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _itemNameField(),
                          _categoryField(),
                          _departmentField(),
                          _propertyField(),
                          _personAccountableField(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _unitField(),
                          _priceField(),
                          _datePurchasedField(),
                          _dateReceivedField(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _itemDescField(),
                          _statusField(),
                          _remarksField(),
                          _countField(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty ||
                          _personAccountableController.text.isNotEmpty ||
                          _unitController.text.isNotEmpty ||
                          _itemDescriptionController.text.isNotEmpty ||
                          _remarksController.text.isNotEmpty) {
                        showCancelDialog(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.trim().isEmpty) {
                        EasyLoading.showError(
                          'Required fields must not be empty',
                        );

                        return;
                      }

                      EasyLoading.show();

                      int count = int.tryParse(_countController.text.trim()) ?? 1;

                      try {
                        List<Department>? departments = ref.read(departmentsNotifierProvider).valueOrNull;
                        List<ItemCategory>? categories = ref.read(categoriesNotifierProvider).valueOrNull;

                        if (departments == null) {
                          return Future.error('No Departments Found');
                        }
                        if (categories == null) {
                          return Future.error('No Categories Found');
                        }

                        for (int i = 0; i < count; i++) {
                          Item item = Item.toDatabase(
                            personAccountable: _personAccountableController.text.trim(),
                            department: _department,
                            name: _nameController.text.trim(),
                            description: _itemDescriptionController.text.trim(),
                            unit: _unitController.text.trim(),
                            price: _isPurchased
                                ? _priceController.text.trim().isEmpty
                                    ? 0
                                    : double.tryParse(_priceController.text.trim())
                                : null,
                            datePurchased: _isPurchased ? _datePurchased : null,
                            dateReceived: _dateReceived,
                            status: _itemStatus,
                            category: _category,
                            property: _property,
                            remarks: _remarksController.text.trim(),
                            lastScanned: DateTime.now(),
                          );

                          await DatabaseAPI.addItem(item: item);
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);

                        EasyLoading.dismiss();

                        await refreshInventory(ref);
                      } catch (e, st) {
                        showErrorAndStacktrace(e, st);
                        return;
                      }
                    },
                    child: const Text('Apply'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCancelDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Column _itemNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Item Name'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            maxLength: 45,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: _nameController,
            decoration: const InputDecoration(hintText: '(required)'),
          ),
        ),
      ],
    );
  }

  Column _itemDescField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Item Description'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 500,
          child: TextField(
            maxLength: 250,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: _itemDescriptionController,
            maxLines: 8,
            minLines: 4,
          ),
        ),
      ],
    );
  }

  Column _remarksField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Remarks'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 500,
          child: TextField(
            maxLength: 250,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: _remarksController,
            maxLines: 8,
            minLines: 4,
          ),
        ),
      ],
    );
  }

  Column _departmentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Department'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<Department>(
              isDense: true,
              isExpanded: true,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: _department,
              items: _departments.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.departmentName),
                );
              }).toList(),
              onChanged: (Department? dept) {
                if (dept == null) return;
                setState(() {
                  _department = dept;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _propertyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Property'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<Property>(
              isDense: true,
              isExpanded: true,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: _property,
              items: _properties.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.propertyName),
                );
              }).toList(),
              onChanged: (Property? property) {
                if (property == null) return;
                setState(() {
                  _property = property;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _personAccountableField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Person Accountable'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            maxLength: 45,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: _personAccountableController,
          ),
        ),
      ],
    );
  }

  Column _countField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Count',
            ),
            const SizedBox(
              width: 20,
            ),
            Tooltip(
              message: 'Number of copies of items. Items will be displayed\nseperately and with a different Asset ID.',
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _countController,
            inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)],
          ),
        ),
      ],
    );
  }

  Column _priceField() {
    bool isLightMode = ref.watch(themeNotifierProvider).valueOrNull == ThemeMode.light;

    Color color = switch ((_isPurchased, isLightMode)) {
      (true, false) => Colors.white,
      (true, true) => Colors.black,
      (_) => Colors.grey,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isPurchasedCheckbox(),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Price',
          style: TextStyle(color: color),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            enabled: _isPurchased,
            controller: _priceController,
            inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true)],
            decoration: InputDecoration(
              icon: Text(
                '₱',
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _datePurchasedField() {
    bool isLightMode = ref.watch(themeNotifierProvider).valueOrNull == ThemeMode.light;

    Color color = switch ((_isPurchased, isLightMode)) {
      (true, false) => Colors.white,
      (true, true) => Colors.black,
      (_) => Colors.grey,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Purchased',
          style: TextStyle(color: color),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: ListTile(
            enabled: _isPurchased,
            shape: RoundedRectangleBorder(
              borderRadius: defaultBorderRadius,
              side: const BorderSide(color: Colors.grey),
            ),
            title: Text(dateToString(_datePurchased)),
            onTap: () => _datePurchasedPicker(context),
            trailing: const Icon(Icons.calendar_month),
          ),
        ),
      ],
    );
  }

  Widget isPurchasedCheckbox() {
    return SizedBox(
      width: 300,
      child: CheckboxListTile(
        checkColor: Colors.black,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('Is purchased'),
        value: _isPurchased,
        onChanged: (purchased) {
          if (purchased == null) return;
          setState(
            () {
              _isPurchased = purchased;
            },
          );
        },
      ),
    );
  }

  Column _dateReceivedField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date Received'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: defaultBorderRadius,
              side: const BorderSide(color: Colors.grey),
            ),
            title: Text(dateToString(_dateReceived)),
            onTap: () => _dateReceivedPicker(context),
            trailing: const Icon(Icons.calendar_month),
          ),
        ),
      ],
    );
  }

  Column _statusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Status'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 200,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<ItemStatus>(
              isDense: true,
              isExpanded: true,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: _itemStatus,
              items: ItemStatus.values
                  .map<DropdownMenuItem<ItemStatus>>((value) => DropdownMenuItem<ItemStatus>(value: value, child: Text(value.name)))
                  .toList(),
              onChanged: (ItemStatus? status) {
                if (status == null) return;
                setState(() {
                  _itemStatus = status;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _unitField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Unit'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            maxLength: 30,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: _unitController,
          ),
        ),
      ],
    );
  }

  Column _categoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: Autocomplete<ItemCategory>(
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              focusNode.addListener(() {
                if (!focusNode.hasFocus) {
                  // checks if the current text in the controller is a category name
                  // if true, returns that category,
                  // if false, returns last category that was matched
                  ItemCategory? buffer =
                      _categories.singleWhere((element) => element.categoryName == textEditingController.text.trim(), orElse: () => _category);

                  textEditingController.text = buffer.categoryName;
                }
              });

              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
              );
            },
            initialValue: TextEditingValue(text: _category.categoryName),
            optionsBuilder: (TextEditingValue option) {
              return _categories.where((element) => element.categoryName.toLowerCase().contains(option.text.toLowerCase().trim()));
            },
            displayStringForOption: (option) => option.categoryName,
            onSelected: (option) => _category = option,
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
                    width: 300, // <-- Right here !
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
          ),
        ),
      ],
    );
  }

  Future _datePurchasedPicker(
    BuildContext context,
  ) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _datePurchased,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );

    if (newDate == null) {
      return;
    } else {
      setState(() {
        _datePurchased = newDate;
      });
    }
  }

  Future _dateReceivedPicker(
    BuildContext context,
  ) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _dateReceived,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );

    if (newDate == null) {
      return;
    } else {
      setState(() {
        _dateReceived = newDate;
      });
    }
  }
}
