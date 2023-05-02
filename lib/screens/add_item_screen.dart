import 'package:flutter/material.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

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
                          itemDescField(),
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
                    child: const Text('Add'),
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
          width: 300,
          child: TextField(),
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
          width: 300,
          child: TextField(),
        ),
      ],
    );
  }

  Column priceField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price'),
        SizedBox(
          width: 300,
          child: TextField(),
        ),
      ],
    );
  }

  Column datePurchasedField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Purchased'),
        SizedBox(
          width: 300,
          child: TextField(),
        ),
      ],
    );
  }

  Column dateReceivedField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Received'),
        SizedBox(
          width: 300,
          child: TextField(),
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
          width: 300,
          child: TextField(),
        ),
      ],
    );
  }
}
