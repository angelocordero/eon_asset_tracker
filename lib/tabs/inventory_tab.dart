// ignore_for_file: use_build_context_synchronously

import 'package:eon_asset_tracker/inventory_advanced_search/advanced_database_api.dart';
import 'package:eon_asset_tracker/notifiers/theme_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import '../core/constants.dart';
import '../core/custom_route.dart';
import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../inventory_advanced_search/advanced_inventory_notifier.dart';
import '../inventory_advanced_search/inventory_advanced_search_bar.dart';
import '../inventory_advanced_search/notifiers.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';
import '../notifiers/categories_notifier.dart';
import '../notifiers/dashboard_notifiers.dart';
import '../notifiers/departments_notifier.dart';
import '../notifiers/sorted_inventory_notifier.dart';
import '../pdf/qr_code_pdf.dart';
import '../pdf/report_pdf.dart';
import '../screens/add_item_screen.dart';
import '../screens/edit_item_screen.dart';
import '../widgets/admin_password_prompt.dart';
import '../widgets/inventory_checkbox.dart';
import '../widgets/item_info_display.dart';

class InventoryTab extends ConsumerWidget {
  const InventoryTab({super.key});

  static final List<String> columns = [
    'A S S E T   I D',
    'I T E M   N A M E',
    'D E P A R T M E N T',
    'P E R S O N\nA C C O U N T A B L E',
    'C A T E G O R Y',
    'S T A T U S',
    'U N I T',
    'P R I C E',
    'D A T E\nP U R C H A S E D',
    'D A T E\nR E C E I V E D',
    'L A S T\nS C A N N E D',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeNotifierProvider).valueOrNull ?? ThemeMode.light;

    return ref.watch(sortedInventoryItemsProvider).when(
      data: (rows) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10),
          child: Column(
            children: [
              header(context, ref),
              Flexible(
                flex: 7,
                child: StickyHeadersTable(
                  onColumnTitlePressed: (columnIndex) {
                    TableColumn column = TableColumn.values[columnIndex];
                    SortOrder? sort = ref.read(tableSortingProvider).sortOrder;

                    if (sort == null || sort == SortOrder.descending) {
                      sort = SortOrder.ascending;
                    } else {
                      sort = SortOrder.descending;
                    }

                    ref.read(tableSortingProvider.notifier).state = (tableColumn: column, sortOrder: sort);
                  },
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
                      150,
                    ],
                    contentCellHeight: 80,
                    stickyLegendWidth: 80,
                    stickyLegendHeight: 80,
                  ),
                  columnsLength: columns.length,
                  rowsLength: rows.length,
                  columnsTitleBuilder: (i) {
                    TableSort tableSort = ref.watch(tableSortingProvider);

                    return Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              columns[i],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: tableSort.tableColumn == TableColumn.values[i],
                          replacement: const Icon(
                            Icons.arrow_downward,
                            color: Colors.transparent,
                          ),
                          child: (tableSort.sortOrder ?? SortOrder.ascending) == SortOrder.ascending
                              ? const Icon(Icons.arrow_upward)
                              : const Icon(Icons.arrow_downward),
                        )
                      ],
                    );
                  },
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
                        return copyableTableDataTile(item.assetID, selected, themeMode);
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
                      case 10:
                        return lastScannedTile(item.lastScanned, selected);

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
      },
      error: (e, st) {
        return Center(
          child: Text(
            e.toString(),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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

  Widget lastScannedTile(DateTime lastScannedDate, bool selected) {
    return Container(
      color: selected ? Colors.blueGrey : Colors.transparent,
      child: ListTile(
        horizontalTitleGap: 0,
        title: lastScannedFormatter(lastScannedDate),
        selectedTileColor: Colors.blueGrey,
        selectedColor: Colors.white,
      ),
    );
  }

  Widget copyableTableDataTile(String text, bool selected, ThemeMode themeMode) {
    return Container(
      color: selected ? Colors.blueGrey : Colors.transparent,
      child: ListTile(
        horizontalTitleGap: 0,
        title: Tooltip(
          message: 'Copy Asset ID to clipboard',
          child: TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              EasyLoading.showInfo('Asset ID copied to clipboard');
            },
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'RobotoMono',
                color: themeMode == ThemeMode.light ? Colors.black : Colors.white,
              ),
            ),
          ),
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
                User? user = await ref.read(userProvider);

                if (user == null) return;

                await adminCheck(
                  context: context,
                  user: user,
                  callback: () async {
                    EasyLoading.show();

                    String? selectedAssetID = ref.read(selectedItemProvider)?.assetID;

                    if (selectedAssetID == null) return;

                    try {
                      await DatabaseAPI.deleteItem(selectedAssetID);
                      EasyLoading.dismiss();
                    } catch (e) {
                      EasyLoading.showError(e.toString());
                      return;
                    }

                    Navigator.pop(context);

                    ref.invalidate(isAdvancedFilterNotifierProvider);
                    ref.invalidate(currentInventoryPage);
                    ref.invalidate(dashboardCategoriesProvider);
                    ref.invalidate(dashboardDepartmentsProvider);
                    ref.invalidate(dashboardStatusProvider);
                    ref.invalidate(advancedInventoryNotifierProvider);
                  },
                );
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

  Widget header(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.max,
      children: [
        const AdvancedInventorySearch(),
        const Spacer(),
        const VerticalDivider(),
        Row(
          children: [
            Tooltip(
              message: 'Generate Report',
              child: IconButton.outlined(
                onPressed: () async {
                  EasyLoading.show();

                  List<Item> items = [];

                  try {
                    items = await AdvancedDatabaseAPI.getItemsForReport(
                      searchData: ref.read(advancedSearchDataNotifierProvider),
                      filters: ref.read(activeSearchFiltersNotifierProvider),
                    );

                    if (items.isNotEmpty) {
                      EasyLoading.dismiss();
                    } else {
                      return await Future.error('Error in generating report');
                    }

                    await showReportDialog(
                      context,
                      items.length,
                      () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('Print Report'),
                                ),
                                body: PdfPreview(
                                  build: (format) async => await ReportPDF(
                                    inventoryItems: items,
                                  ).generate(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } catch (e, st) {
                    showErrorAndStacktrace(e, st);
                    return;
                  }
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
                  List<Item> items = [];

                  if (true) {
                    items = ref.read(checkedItemProvider).map((entry) {
                      return ref.read(advancedInventoryNotifierProvider).asData!.value.items.firstWhere((element) => element.assetID == entry);
                    }).toList();
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text('Print QR Code'),
                          ),
                          body: PdfPreview(
                            build: (format) async => await QRCodePDF(
                              items: items,
                              departments: ref.read(departmentsNotifierProvider).requireValue,
                              categories: ref.read(categoriesNotifierProvider).requireValue,
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
                  ref.invalidate(isAdvancedFilterNotifierProvider);
                  ref.invalidate(currentInventoryPage);
                  ref.invalidate(dashboardCategoriesProvider);
                  ref.invalidate(dashboardDepartmentsProvider);
                  ref.invalidate(dashboardStatusProvider);
                  ref.invalidate(advancedInventoryNotifierProvider);
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
                onPressed: () async {
                  Item? item = await ref.read(selectedItemProvider);

                  if (item == null) return;

                  User? user = await ref.read(userProvider);

                  if (user == null) return;

                  await adminCheck(
                    context: context,
                    user: user,
                    callback: () async {
                      await Navigator.push(
                        context,
                        CustomRoute(
                          builder: (context) {
                            return EditItemScreen(item: item);
                          },
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            Tooltip(
              message: 'Add new item',
              child: IconButton.outlined(
                onPressed: () async {
                  User? user = await ref.read(userProvider);

                  if (user == null) return;

                  await adminCheck(
                    context: context,
                    user: user,
                    callback: () async {
                      await Navigator.push(
                        context,
                        CustomRoute(
                          builder: (context) {
                            return const AddItemScreen();
                          },
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> adminCheck({required BuildContext context, required User user, required AsyncCallback callback}) async {
    if (!user.isAdmin) {
      Navigator.push(
        context,
        CustomRoute(
          builder: (context) {
            final TextEditingController controller = TextEditingController();

            return AdminPasswordPrompt(
              controller: controller,
              callback: () async {
                bool admin = await DatabaseAPI.getAdminPassword(controller.text.trim());

                if (admin) {
                  Navigator.pop(context);

                  await callback();
                } else {
                  EasyLoading.showError('Wrong admin password');
                }
              },
            );
          },
        ),
      );
    } else {
      await callback();
    }
  }
}
