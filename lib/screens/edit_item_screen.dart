import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';

class EditItemScreen extends ConsumerStatefulWidget {
  const EditItemScreen({super.key, required this.item});

  final Item item;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 365 * 5));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 5));

  late TextEditingController _nameController;
  late TextEditingController _personAccountableController;
  late TextEditingController _priceController;
  late TextEditingController _unitController;
  late TextEditingController _itemDescriptionController;
  late TextEditingController _remarksController;

  bool _isPurchased = false;

  @override
  void initState() {
    _nameController = TextEditingController.fromValue(TextEditingValue(text: widget.item.name));
    _personAccountableController = TextEditingController.fromValue(TextEditingValue(text: widget.item.personAccountable ?? ''));
    _priceController =
        TextEditingController.fromValue(TextEditingValue(text: widget.item.price.toString() != 'null' ? widget.item.price.toString() : "0.00"));
    _unitController = TextEditingController.fromValue(TextEditingValue(text: widget.item.unit ?? ''));
    _itemDescriptionController = TextEditingController.fromValue(TextEditingValue(text: widget.item.description ?? ''));
    _remarksController = TextEditingController.fromValue(TextEditingValue(text: widget.item.remarks ?? ''));

    if (widget.item.price != null || widget.item.datePurchased != null) {
      _isPurchased = true;
    }

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
                'Edit Item',
                style: TextStyle(fontSize: 50),
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
                          itemNameField(),
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
                          unitField(),
                          priceField(),
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
                      if (_nameController.text.trim().isEmpty) {
                        EasyLoading.showError(
                          'Required fields must not be empty',
                        );

                        return;
                      }

                      EasyLoading.show();

                      Item newItem = widget.item.copyWith(
                        name: _nameController.text.trim(),
                        personAccountable: _personAccountableController.text.trim(),
                        description: _itemDescriptionController.text.trim(),
                        unit: _unitController.text.trim(),
                        price: _isPurchased
                            ? _priceController.text.trim().isEmpty
                                ? 0
                                : double.tryParse(_priceController.text.trim())
                            : null,
                        // price: price,
                        remarks: _remarksController.text.trim(),
                        datePurchased: _isPurchased ? widget.item.datePurchased ?? DateTime.now() : null,
                      );

                      try {
                        await DatabaseAPI.update(conn: ref.read(sqlConnProvider), item: newItem);

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);

                        EasyLoading.dismiss();

                        ref.read(inventoryProvider.notifier).refresh();
                        ref.read(dashboardDataProvider.notifier).refresh();
                      } catch (e, st) {
                        showErrorAndStacktrace(e, st);
                        return;
                      }
                    },
                    child: const Text('Update'),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
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

  Column itemNameField() {
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
            controller: _nameController,
            decoration: const InputDecoration(hintText: '(required)'),
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
              value: widget.item.department,
              items: ref.watch(departmentsProvider).map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.departmentName),
                );
              }).toList(),
              onChanged: (Department? dept) {
                if (dept == null) return;
                setState(() {
                  widget.item.department = dept;
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
        isPurchasedCheckbox(),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Price',
          style: TextStyle(color: _isPurchased ? Colors.white : Colors.grey),
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
                  color: _isPurchased ? Colors.white : Colors.grey,
                  fontSize: 20,
                ),
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
        Text(
          'Date Purchased',
          style: TextStyle(color: _isPurchased ? Colors.white : Colors.grey),
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
            title: Text(dateToString(widget.item.datePurchased ?? DateTime.now())),
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
            title: Text(dateToString(widget.item.dateReceived)),
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
              value: widget.item.status,
              items: ItemStatus.values
                  .map<DropdownMenuItem<ItemStatus>>((value) => DropdownMenuItem<ItemStatus>(value: value, child: Text(value.name)))
                  .toList(),
              onChanged: (ItemStatus? status) {
                if (status == null) return;
                setState(() {
                  widget.item.status = status;
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
              value: widget.item.category,
              items: ref
                  .watch(categoriesProvider)
                  .map<DropdownMenuItem<ItemCategory>>(
                    (value) => DropdownMenuItem<ItemCategory>(
                      value: value,
                      child: Text(value.categoryName),
                    ),
                  )
                  .toList(),
              onChanged: (ItemCategory? category) {
                if (category == null) return;
                setState(() {
                  widget.item.category = category;
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
      initialDate: widget.item.datePurchased ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    );

    if (newDate == null) {
      return;
    } else {
      setState(() {
        widget.item.datePurchased = DateTime(newDate.year, newDate.month, newDate.day, 12, 0, 0, 0, 0);
      });
    }
  }

  Future _dateReceivedPicker(
    BuildContext context,
  ) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: widget.item.dateReceived,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );

    if (newDate == null) {
      return;
    } else {
      setState(() {
        widget.item.dateReceived = DateTime(newDate.year, newDate.month, newDate.day, 12, 0, 0, 0, 0);
      });
    }
  }
}
