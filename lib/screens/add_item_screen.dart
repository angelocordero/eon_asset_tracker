import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/database_api.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  late List<Department> _departments;
  late List<ItemCategory> _categories;

  late DateTime _datePurchased;
  late DateTime _dateReceived;

  final DateTime _firstDate =
      DateTime.now().subtract(const Duration(days: 365 * 5));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 5));

  late ItemStatus _itemStatus;
  late Department _department;
  late ItemCategory _category;

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _personAccountableController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    _datePurchased = DateTime.now();
    _dateReceived = DateTime.now();

    _departments = ref.read(departmentsProvider);
    _categories = ref.read(categoriesProvider);

    _department = _departments.first;
    _itemStatus = ItemStatus.Good;
    _category = _categories.first;

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
                'Add Item',
                style: TextStyle(fontSize: 50),
              ),
              const SizedBox(
                height: 50,
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
                          itemModelField(),
                          departmentField(),
                          personAccountableField(),
                          categoryField(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          priceField(),
                          unitField(),
                          datePurchasedField(),
                          dateReceivedField(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemDescField(),
                          statusField(),
                          remarksField(),
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
                    onPressed: () async {
                      MySqlConnection? conn = ref.read(sqlConnProvider);

                      if (conn == null) return;

                      Item item = Item.withoutID(
                        personAccountable:
                            _personAccountableController.text.trim(),
                        departmentID: _department.departmentID,
                        model: _modelController.text.trim(),
                        description: _itemDescriptionController.text.trim(),
                        unit: _unitController.text.trim(),
                        price: double.tryParse(_priceController.text.trim()),
                        datePurchased: _datePurchased,
                        dateReceived: _dateReceived,
                        status: _itemStatus.name,
                        categoryID: _category.categoryID,
                        remarks: _remarksController.text.trim(),
                      );

                      await DatabaseAPI.add(
                          conn: ref.read(sqlConnProvider)!, item: item);

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        CustomRoute(
                          builder: (context) {
                            return Center(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: QrImage(
                                    backgroundColor: Colors.white,
                                    data: item.assetID,
                                    size: 300,
                                    version: QrVersions.auto,
                                    // embeddedImageStyle: QrEmbeddedImageStyle(
                                    //     size: const Size(80, 80)),
                                    // embeddedImage:
                                    //     const AssetImage('assets/logo.jpg'),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Apply'),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column itemModelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Item Model / Serial Number'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            controller: _modelController,
          ),
        ),
      ],
    );
  }

  Column itemDescField() {
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
            controller: _itemDescriptionController,
            maxLines: 8,
            minLines: 4,
          ),
        ),
      ],
    );
  }

  Column remarksField() {
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
            controller: _remarksController,
            maxLines: 8,
            minLines: 4,
          ),
        ),
      ],
    );
  }

  Column departmentField() {
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

  Column personAccountableField() {
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
            controller: _personAccountableController,
          ),
        ),
      ],
    );
  }

  Column priceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            controller: _priceController,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true)
            ],
            decoration: const InputDecoration(
              icon: Text(
                '₱',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column datePurchasedField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date Purchased'),
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
            title: Text(dateToString(_datePurchased)),
            onTap: () => _datePurchasedPicker(context),
            trailing: const Icon(Icons.calendar_month),
          ),
        ),
      ],
    );
  }

  Column dateReceivedField() {
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

  Column statusField() {
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
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: _itemStatus,
              items: ItemStatus.values
                  .map<DropdownMenuItem<ItemStatus>>((value) =>
                      DropdownMenuItem<ItemStatus>(
                          value: value, child: Text(value.name)))
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

  Column unitField() {
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
            controller: _unitController,
          ),
        ),
      ],
    );
  }

  Column categoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<ItemCategory>(
              isDense: true,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: _category,
              items: _categories
                  .map<DropdownMenuItem<ItemCategory>>((value) =>
                      DropdownMenuItem<ItemCategory>(
                          value: value, child: Text(value.categoryName)))
                  .toList(),
              onChanged: (ItemCategory? category) {
                if (category == null) return;
                setState(() {
                  _category = category;
                });
              },
            ),
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
