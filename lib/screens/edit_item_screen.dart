import 'package:eon_asset_tracker/models/property_model.dart';
import 'package:eon_asset_tracker/notifiers/properties_notifier.dart';
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
import '../notifiers/categories_notifier.dart';
import '../notifiers/departments_notifier.dart';

class EditItemScreen extends ConsumerStatefulWidget {
  const EditItemScreen({super.key, required this.item});

  final Item item;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 365 * 10));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 10));

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
                'E D I T   I T E M',
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
                        remarks: _remarksController.text.trim(),
                        datePurchased: _isPurchased ? widget.item.datePurchased ?? DateTime.now() : null,
                      );

                      try {
                        await DatabaseAPI.updateItem(newItem);

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);

                        EasyLoading.dismiss();

                        await refreshInventory(ref);
                      } catch (e, st) {
                        showErrorAndStacktrace(e, st);
                        return;
                      }
                    },
                    child: const Text('Update'),
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
              value: widget.item.property,
              items: ref.watch(propertiesNotifierProvider).requireValue.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.propertyName),
                );
              }).toList(),
              onChanged: (Property? property) {
                if (property == null) return;
                setState(() {
                  widget.item.property = property;
                });
              },
            ),
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
              value: widget.item.department,
              items: ref.watch(departmentsNotifierProvider).requireValue.map((value) {
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

  Column _priceField() {
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

  Column _datePurchasedField() {
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
            title: Text(dateToString(widget.item.dateReceived)),
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

  slide() {
    return Slider(
      value: 0,
      onChanged: (value) {},
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
                  ItemCategory? buffer = ref
                      .read(categoriesNotifierProvider)
                      .requireValue
                      .singleWhere((element) => element.categoryName == textEditingController.text.trim(), orElse: () => widget.item.category);

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
            initialValue: TextEditingValue(text: widget.item.category.categoryName),
            optionsBuilder: (TextEditingValue option) {
              return ref
                  .watch(categoriesNotifierProvider)
                  .requireValue
                  .where((element) => element.categoryName.toLowerCase().contains(option.text.toLowerCase().trim()));
            },
            displayStringForOption: (option) => option.categoryName,
            onSelected: (option) {
              setState(() {
                widget.item.category = option;
              });
            },
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
                    width: 300,
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
