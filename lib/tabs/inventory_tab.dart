import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/screens/add_item_screen.dart';
import 'package:eon_asset_tracker/widgets/item_info_display.dart';
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
    'Status',
    'Price',
    'Unit',
    'Date Purchased',
    'Date Received',
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
              IconButton.outlined(
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
              onContentCellPressed: (i, j) {
                //  print(rows[j].assetID);

                ref.read(selectedItemProvider.notifier).state = rows[j];
              },
              showHorizontalScrollbar: true,
              showVerticalScrollbar: true,
              cellDimensions: const CellDimensions.variableColumnWidth(
                columnWidths: [
                  300,
                  300,
                  200,
                  200,
                  200,
                  150,
                  150,
                  150,
                  250,
                  250,
                ],
                contentCellHeight: 100,
                stickyLegendWidth: 0,
                stickyLegendHeight: 100,
              ),
              columnsLength: columns.length,
              rowsLength: rows.length,
              columnsTitleBuilder: (i) => Text(columns[i]),
              rowsTitleBuilder: (j) => Container(),
              contentCellBuilder: (i, j) {
                Item item = rows[j];

                String? selectedItemAssetID =
                    ref.watch(selectedItemProvider)?.assetID;

                bool selected = item.assetID == selectedItemAssetID;

                switch (i) {
                  case 0:
                    return tableDataTile(item.assetID, selected);
                  case 1:
                    return tableDataTile(item.model, selected);
                  case 2:
                    return tableDataTile(item.department, selected);
                  case 3:
                    return tableDataTile(
                        item.personAccountable.toString(), selected);
                  case 4:
                    return tableDataTile(item.category, selected);
                  case 6:
                    return tableDataTile(
                        item.price == null
                            ? ''
                            : item.price!.toStringAsFixed(2),
                        selected);
                  case 7:
                    return tableDataTile(item.unit, selected);
                  case 8:
                    return tableDataTile(
                        dateToString(item.datePurchased!), selected);
                  case 9:
                    return tableDataTile(
                        dateToString(item.dateReceived!), selected);
                  case 5:
                    return tableDataTile(item.status, selected);
                  default:
                    return Container();
                }
              },
            ),
          ),
          const Divider(),
          const Flexible(
            flex: 1,
            child: ItemInfoDisplay(),
          ),
        ],
      ),
    );
  }

  ListTile tableDataTile(String text, bool selected) {
    return ListTile(
      title: Text(
        text,
        textAlign: TextAlign.center,
      ),
      selected: selected,
      selectedTileColor: Colors.blueGrey,
      selectedColor: Colors.white,
    );
  }
}
