import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/pdf/report_pdf.dart';
import 'package:eon_asset_tracker/screens/add_item_screen.dart';
import 'package:eon_asset_tracker/screens/edit_item_screen.dart';
import 'package:eon_asset_tracker/widgets/item_info_display.dart';
import 'package:eon_asset_tracker/widgets/search_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import '../models/item_model.dart';
import '../pdf/qr_code_pdf.dart';
import '../widgets/inventory_checkbox.dart';

class InventoryTab extends ConsumerWidget {
  const InventoryTab({super.key});

  static final List<String> columns = [
    'Asset ID',
    'Item Name',
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
      child: Visibility(
        visible: ref.watch(inventoryProvider.notifier).isLoading,
        replacement: Column(
          children: [
            header(context, ref),
            Flexible(
              flex: 7,
              child: StickyHeadersTable(
                legendCell: Center(
                  child: Checkbox(
                    value: ref.watch(checkedItemProvider).length == rows.length,
                    onChanged: (checked) {
                      if (checked == null) return;
                      List<String> buffer = ref.read(checkedItemProvider);

                      if (checked) {
                        buffer.addAll(rows.map((e) => e.assetID).toList());
                      } else {
                        buffer.clear();
                      }

                      ref.read(checkedItemProvider.notifier).state = buffer.toSet().toList();
                    },
                  ),
                ),
                onContentCellPressed: (i, j) {
                  ref.read(selectedItemProvider.notifier).state = rows[j];
                },
                showHorizontalScrollbar: false,
                showVerticalScrollbar: true,
                cellDimensions: const CellDimensions.variableColumnWidth(
                  columnWidths: [
                    250,
                    250,
                    200,
                    250,
                    200,
                    150,
                    150,
                    150,
                    220,
                    220,
                  ],
                  contentCellHeight: 80,
                  stickyLegendWidth: 80,
                  stickyLegendHeight: 80,
                ),
                columnsLength: columns.length,
                rowsLength: rows.length,
                columnsTitleBuilder: (i) => Text(columns[i]),
                rowsTitleBuilder: (j) {
                  Item item = rows[j];

                  return Row(
                    children: [
                      Text((j + 1).toString()),
                      const SizedBox(
                        width: 15,
                      ),
                      InventoryCheckbox(assetID: item.assetID),
                    ],
                  );
                },
                contentCellBuilder: (i, j) {
                  Item item = rows[j];

                  String? selectedItemAssetID = ref.watch(selectedItemProvider)?.assetID;

                  bool selected = item.assetID == selectedItemAssetID;

                  switch (i) {
                    case 0:
                      return tableDataTile(item.assetID, selected);
                    case 1:
                      return tableDataTile(item.name, selected);
                    case 2:
                      return tableDataTile(item.department.departmentName, selected);
                    case 3:
                      return tableDataTile(item.personAccountable ?? '', selected);
                    case 4:
                      return tableDataTile(item.category.categoryName, selected);
                    case 5:
                      return tableDataTile(item.status.name, selected);
                    case 6:
                      return tableDataTile(item.unit ?? '', selected);
                    case 7:
                      return tableDataTile(priceToString(item.price), selected);
                    case 8:
                      return tableDataTile(item.datePurchased == null ? '' : dateToString(item.datePurchased!), selected);
                    case 9:
                      return tableDataTile(dateToString(item.dateReceived), selected);

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
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget tableDataTile(String text, bool selected) {
    return Container(
      color: selected ? Colors.blueGrey : Colors.transparent,
      child: ListTile(
        horizontalTitleGap: 0,
        title: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        selectedTileColor: Colors.blueGrey,
        selectedColor: Colors.white,
      ),
    );
  }

  Future<dynamic> showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
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

                String? selectedAssetID = ref.read(selectedItemProvider)?.assetID;

                if (selectedAssetID == null) return;

                try {
                  await DatabaseAPI.delete(selectedAssetID);
                  EasyLoading.dismiss();
                } catch (e) {
                  EasyLoading.showError(e.toString());
                  return;
                }

                // ignore: use_build_context_synchronously
                Navigator.pop(context);

                await ref.read(inventoryProvider.notifier).refresh();

                await ref.read(dashboardDataProvider.notifier).refresh();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showReportDialog(BuildContext context, int itemLength, AsyncCallback callback) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Generate report for $itemLength items?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await callback();
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
          message: 'Generate Report',
          child: IconButton.outlined(
            onPressed: () async {
              int itemLength = ref.read(inventoryProvider).length;

              if (itemLength == 0) return;

              await showReportDialog(
                context,
                itemLength,
                () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text('Print QR Code'),
                          ),
                          body: PdfPreview(
                            build: (format) async => await ReportPDF(
                              inventoryItems: ref.read(inventoryProvider),
                              departments: ref.read(departmentsProvider),
                              categories: ref.read(categoriesProvider),
                            ).generate(),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.print),
          ),
        ),
        Tooltip(
          message: 'Print QR Codes',
          child: IconButton.outlined(
            onPressed: () {
              if (ref.read(checkedItemProvider).isEmpty) {
                EasyLoading.showInfo('No items selected by checkbox');
                return;
              }

              List<Item> items = ref.read(checkedItemProvider).map((entry) {
                return ref.read(inventoryProvider).firstWhere((element) => element.assetID == entry);
              }).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Print QR Code'),
                      ),
                      body: PdfPreview(
                        build: (format) => QRCodePDF(
                          items: items,
                          departments: ref.read(departmentsProvider),
                          categories: ref.read(categoriesProvider),
                        ).generate(),
                      ),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.qr_code),
          ),
        ),
        Tooltip(
          message: 'Refresh page',
          child: IconButton.outlined(
            onPressed: () {
              ref.read(checkedItemProvider.notifier).state = [];
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
            onPressed: () async {
              await showDeleteDialog(
                context,
                ref,
              );
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
