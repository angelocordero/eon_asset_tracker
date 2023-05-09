import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/screens/add_item_screen.dart';
import 'package:eon_asset_tracker/screens/edit_item_screen.dart';
import 'package:eon_asset_tracker/widgets/item_info_display.dart';
import 'package:eon_asset_tracker/widgets/search_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import '../models/item_model.dart';

class InventoryTab extends ConsumerWidget {
  const InventoryTab({super.key});

  static final List<String> columns = [
    'Asset ID',
    'Item Model /\nSerial Number',
    'Department',
    'Person Accountable',
    'Category',
    'Status',
    'Unit',
    'Price',
    'Date Purchased',
    'Date Received',
  ];

  static final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Item> rows = ref.watch(inventoryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10),
      child: Column(
        children: [
          header(context, ref),
          Flexible(
            flex: 7,
            child: StickyHeadersTable(
              onContentCellPressed: (i, j) {
                ref.read(selectedItemProvider.notifier).state = rows[j];
              },
              showHorizontalScrollbar: false,
              showVerticalScrollbar: true,
              cellDimensions: const CellDimensions.variableColumnWidth(
                columnWidths: [
                  250,
                  250,
                  180,
                  180,
                  180,
                  120,
                  180,
                  120,
                  220,
                  220,
                ],
                contentCellHeight: 80,
                stickyLegendWidth: 50,
                stickyLegendHeight: 80,
              ),
              columnsLength: columns.length,
              rowsLength: rows.length,
              columnsTitleBuilder: (i) => Text(columns[i]),
              rowsTitleBuilder: (j) => Text((j + 1).toString()),
              contentCellBuilder: (i, j) {
                Item item = rows[j];

                String? selectedItemAssetID =
                    ref.watch(selectedItemProvider)?.assetID;

                bool selected = item.assetID == selectedItemAssetID;

                String categoryName = ref
                    .read(categoriesProvider)
                    .firstWhere(
                        (element) => element.categoryID == item.categoryID)
                    .categoryName;

                String departmentName = ref
                    .read(departmentsProvider)
                    .firstWhere(
                        (element) => element.departmentID == item.departmentID)
                    .departmentName;

                switch (i) {
                  case 0:
                    return tableDataTile(item.assetID, selected);
                  case 1:
                    return tableDataTile(item.model, selected);
                  case 2:
                    return tableDataTile(departmentName, selected);
                  case 3:
                    return tableDataTile(
                        item.personAccountable ?? '', selected);
                  case 4:
                    return tableDataTile(categoryName, selected);
                  case 5:
                    return tableDataTile(item.status.name, selected);
                  case 6:
                    return tableDataTile(item.unit, selected);
                  case 7:
                    return tableDataTile(priceToString(item.price), selected);
                  case 8:
                    return tableDataTile(
                        item.datePurchased == null
                            ? ''
                            : dateToString(item.datePurchased!.toLocal()),
                        selected);
                  case 9:
                    return tableDataTile(
                        dateToString(item.dateReceived.toLocal()), selected);

                  default:
                    return Container();
                }
              },
            ),
          ),
          const Divider(),
          const Flexible(
            flex: 2,
            child: ItemInfoDisplay(),
          ),
        ],
      ),
    );
  }

  Widget tableDataTile(String text, bool selected) {
    return Container(
      color: selected ? Colors.blueGrey : Colors.transparent,
      child: ListTile(
        title: Text(
          text,
          textAlign: TextAlign.center,
        ),
        selectedTileColor: Colors.blueGrey,
        selectedColor: Colors.white,
      ),
    );
  }

  Future<dynamic> showDeleteDialog(
      BuildContext context, AsyncCallback callback) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                EasyLoading.show();

                Navigator.pop(context);
                await callback();
                EasyLoading.dismiss();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Row header(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SearchWidget(controller: _searchController),
        const Spacer(),
        Tooltip(
          message: 'Refresh page',
          child: IconButton.outlined(
            onPressed: () {
              ref.read(inventoryProvider.notifier).refresh();

              _searchController.clear();
              ref.read(searchQueryProvider.notifier).state = 'Asset ID';
            },
            icon: const Icon(Icons.refresh),
          ),
        ),
        Tooltip(
          message: 'Delete selected item',
          child: IconButton.outlined(
            onPressed: () {
              showDeleteDialog(context, () async {
                String? selectedAssetID =
                    ref.read(selectedItemProvider)?.assetID;

                if (selectedAssetID == null) return;

                await DatabaseAPI.delete(
                    conn: ref.read(sqlConnProvider), assetID: selectedAssetID);

                await ref.read(inventoryProvider.notifier).refresh();

                await ref.read(dashboardDataProvider.notifier).refresh();
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ),
        Tooltip(
          message: 'Edit selected item',
          child: IconButton.outlined(
            onPressed: () {
              Item? item = ref.read(selectedItemProvider);

              if (item == null) return;

              Navigator.push(
                context,
                CustomRoute(
                  builder: (context) {
                    return EditItemScreen(item: item);
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ),
        Tooltip(
          message: 'Add new item',
          child: IconButton.outlined(
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
        ),
      ],
    );
  }
}
