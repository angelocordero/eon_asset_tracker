// import 'package:eon_asset_tracker/inventory_advanced_search/advanced_database_api.dart';
// import 'package:mysql_client/mysql_client.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../core/constants.dart';
// import '../core/database_api.dart';
// import '../core/providers.dart';
// import '../core/utils.dart';
// import '../inventory_advanced_search/notifiers.dart';
// import '../models/inventory_model.dart';
// import 'categories_notifier.dart';
// import 'departments_notifier.dart';

// part 'inventory_notifier.g.dart';

// @Riverpod(keepAlive: true)
// class InventoryNotifier extends _$InventoryNotifier {
//   @override
//   FutureOr<Inventory> build() async {
//     state = const AsyncLoading();

//     ref.watch(categoriesNotifierProvider);
//     ref.watch(departmentsNotifierProvider);

//     MySQLConnection conn = await createSqlConn();
//     await conn.connect();

//     Inventory inventory = Inventory(
//       items: await DatabaseAPI.getInventoryUnfiltered(page: 0, itemsPerPage: ref.watch(itemsPerPageProvider)),
//       count: await DatabaseAPI.getTotalInventoryCount(conn),
//     );

//     if (conn.connected) {
//       await conn.close();
//     }

//     return inventory;
//   }

//   Future<void> getAdvancedFilteredInvetory() async {
//     state = await AsyncValue.guard(() async {
//       MySQLConnection conn = await createSqlConn();
//       await conn.connect();

//       Inventory inventory = await AdvancedDatabaseAPI.advancedSearch(
//         conn: conn,
//         page: ref.read(currentInventoryPage),
//         itemsPerPage: ref.read(itemsPerPageProvider),
//         searchData: ref.read(advancedSearchDataNotifierProvider),
//         filters: ref.read(activeSearchFiltersNotifierProvider),
//       )
//       ;
//       ref.read(isAdvancedFilterNotifierProvider.notifier).activate();

//       if (conn.connected) {
//         await conn.close();
//       }

//       return inventory;
//     });
//   }

//   Future<void> initFilteredInventory() async {
//     dynamic query = ref.read(searchQueryProvider);
//     InventorySearchFilter filter = ref.read(searchFilterProvider);

//     state = await AsyncValue.guard(() async {
//       MySQLConnection conn = await createSqlConn();
//       await conn.connect();

//       Inventory inventory = Inventory(
//         items: await DatabaseAPI.searchInventory(query: query, filter: filter, page: 0, itemsPerPage: ref.read(itemsPerPageProvider)),
//         count: await DatabaseAPI.getSearchResultTotalCount(query: query, filter: filter),
//       );

//       if (conn.connected) {
//         await conn.close();
//       }

//       return inventory;
//     });
//   }

//   Future<void> getInventoryFromPage(int page) async {
//     dynamic query = ref.read(searchQueryProvider);

//     if (query == null || query == '') {
//       await _getUnfilteredFromPage(page);
//     } else {
//       await _searchFromPage(
//         page: page,
//       );
//     }
//   }

//   Future<void> _getUnfilteredFromPage(int page) async {
//     state = await AsyncValue.guard(
//       () async {
//         return Inventory(
//           items: await DatabaseAPI.getInventoryUnfiltered(page: page, itemsPerPage: ref.read(itemsPerPageProvider)),
//           count: state.asData?.valueOrNull?.count ?? 0,
//         );
//       },
//     );
//   }

//   Future<void> _searchFromPage({
//     required int page,
//   }) async {
//     dynamic query = ref.read(searchQueryProvider);
//     InventorySearchFilter filter = ref.read(searchFilterProvider);

//     if (query == '') {
//       ref.invalidateSelf();
//       return;
//     }

//     state = await AsyncValue.guard(
//       () async {
//         return Inventory(
//           items: await DatabaseAPI.searchInventory(
//             query: query,
//             filter: filter,
//             page: page,
//             itemsPerPage: ref.read(itemsPerPageProvider),
//           ),
//           count: state.asData?.valueOrNull?.count ?? 0,
//         );
//       },
//     );
//   }
// }
