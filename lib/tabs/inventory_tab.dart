import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/screens/add_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import '../models/item_model.dart';

class InventoryTab extends ConsumerWidget {
  const InventoryTab({super.key});

  //static final ScrollController _scrollController = ScrollController();

  static final List<String> columns = [
    'Asset ID',
    'Item Model / Serial Number',
    'Department',
    'Person Accountable',
    'Category',
    'Price',
    'Unit',
    'Date Purchased',
    'Date Received',
    'Status',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Item> rows = ref.watch(inventoryProvider);

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
            child: StickyHeadersTable(
              showHorizontalScrollbar: true,
              cellDimensions: const CellDimensions.variableColumnWidth(
                  columnWidths: null,
                  contentCellHeight: null,
                  stickyLegendWidth: 200,
                  stickyLegendHeight: 100),
              columnsLength: columns.length,
              rowsLength: rows.length,
              columnsTitleBuilder: (i) => Text(columns[i]),
              rowsTitleBuilder: (j) => Container(),
              contentCellBuilder: (i, j) {
                Item item = rows[j];

                switch (i) {
                  case 0:
                    return Text(item.assetID);
                  case 1:
                    return Text(item.model);
                  case 2:
                    return Text(item.department);
                  case 3:
                    return Text(item.personAccountable.toString());
                  case 4:
                    return Text(item.category);
                  case 5:
                    return Text(item.price == null
                        ? '0.00'
                        : item.price!.toStringAsFixed(2));
                  case 6:
                    return Text(item.unit);
                  case 7:
                    return Text(dateToString(item.datePurchased!));
                  case 8:
                    return Text(dateToString(item.dateReceived!));
                  case 9:
                    return Text(item.status);
                  default:
                    return Container();
                }
              },
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
