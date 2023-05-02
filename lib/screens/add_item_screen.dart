import 'package:eon_asset_tracker/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late DateTime _datePurchased;
  late DateTime _dateReceived;

  DateTime firstDate = DateTime.now().subtract(const Duration(days: 365 * 5));
  DateTime lastDate = DateTime.now().add(const Duration(days: 365 * 5));

  @override
  void initState() {
    _datePurchased = DateTime.now();
    _dateReceived = DateTime.now();
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
                    onPressed: () {},
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Item Model / Serial Number'),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(),
        ),
      ],
    );
  }

  Column itemDescField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Item Description'),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 500,
          child: TextField(
            maxLines: 10,
            minLines: 4,
          ),
        ),
      ],
    );
  }

  Column departmentField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Department'),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(),
        ),
      ],
    );
  }

  Column personAccountableField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Person Accountable'),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(),
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
              borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.circular(12),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status'),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(),
        ),
      ],
    );
  }

  Column unitField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Unit'),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(),
        ),
      ],
    );
  }

  Column categoryField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category'),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(),
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
      firstDate: firstDate,
      lastDate: lastDate,
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
      firstDate: firstDate,
      lastDate: lastDate,
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
