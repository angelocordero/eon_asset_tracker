import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/screens/add_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryTab extends ConsumerWidget {
  const InventoryTab({super.key});

  static final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomRoute(
                      builder: (context) {
                        return const AddItemScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Flexible(
            flex: 3,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                primary: true,
                child: DataTable(
                  columns: _columns(),
                  rows: _rows(ref),
                  showCheckboxColumn: false,
                  showBottomBorder: true,
                ),
              ),
            ),
          ),
          const Divider(),
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _rows(WidgetRef ref) {
    return ref.watch(inventoryProvider).map<DataRow>((item) {
      return DataRow(cells: [
        DataCell(Text(item.assetID)),
        DataCell(Text(item.model)),
        DataCell(Text(item.department)),
        DataCell(Text(item.personAccountable.toString())),
        DataCell(Text(item.category)),
        DataCell(Text(item.price.toString())),
        DataCell(Text(item.unit)),
        DataCell(Text(dateToString(item.dateReceived!))),
        DataCell(Text(dateToString(item.dateReceived!))),
        DataCell(Text(item.status)),
      ]);
    }).toList();
  }

  List<DataColumn> _columns() {
    return <DataColumn>[
      const DataColumn(
        label: Text(
          'Asset ID',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Item Model /\nSerial Number',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Department',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Person\nAccountable',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Category',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Price',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Unit',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Date Purchased',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Date Received',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const DataColumn(
        label: Text(
          'Status',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ];
  }
}
