import 'package:eon_asset_tracker/inventory_advanced_search/advanced_inventory_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants.dart';
import '../core/providers.dart';
import '../models/inventory_model.dart';
import '../models/item_model.dart';

part 'sorted_inventory_notifier.g.dart';

@riverpod
AsyncValue<List<Item>> sortedInventoryItems(SortedInventoryItemsRef ref) {
  TableSort sort = ref.watch(tableSortingProvider);

  return ref.watch(advancedInventoryNotifierProvider).when(
        data: (Inventory inventory) {
          inventory.sort(sort);

          return AsyncData(inventory.items);
        },
        error: (e, st) => AsyncError(e, st),
        loading: () => const AsyncLoading(),
      );
}
