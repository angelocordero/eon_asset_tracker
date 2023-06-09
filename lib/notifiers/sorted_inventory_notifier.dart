import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants.dart';
import '../core/providers.dart';
import '../models/inventory_model.dart';
import '../models/item_model.dart';
import 'inventory_notifier.dart';

part 'sorted_inventory_notifier.g.dart';

@riverpod
AsyncValue<List<Item>> sortedInventoryItems(SortedInventoryItemsRef ref) {
  TableSort sort = ref.watch(tableSortingProvider);

  return ref.watch(inventoryNotifierProvider).when(
        data: (Inventory inventory) {
          inventory.sort(sort);

          return AsyncData(inventory.items);
        },
        error: (e, st) => AsyncError(e, st),
        loading: () => const AsyncLoading(),
      );
}
