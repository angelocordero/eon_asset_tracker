import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../inventory_advanced_search/advanced_inventory_notifier.dart';
import '../inventory_advanced_search/notifiers.dart';
import '../models/category_model.dart';

part 'categories_notifier.g.dart';

@Riverpod(keepAlive: true)
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  FutureOr<List<ItemCategory>> build() async {
    state = const AsyncLoading();

    return await DatabaseAPI.getCategories();
  }

  Future<void> addCategory(String categoryName) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.addCategory(categoryName);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
    ref.invalidate(activeSearchFiltersNotifierProvider);
    ref.invalidate(advancedSearchDataNotifierProvider);
    ref.invalidate(isAdvancedFilterNotifierProvider);
    ref.invalidate(currentInventoryPage);
    ref.invalidate(advancedInventoryNotifierProvider);
  }

  Future<void> editCategory(ItemCategory category) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.editCategory(category);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
    ref.invalidate(activeSearchFiltersNotifierProvider);
    ref.invalidate(advancedSearchDataNotifierProvider);
    ref.invalidate(isAdvancedFilterNotifierProvider);
    ref.invalidate(currentInventoryPage);
    ref.invalidate(advancedInventoryNotifierProvider);
  }

  Future<void> deleteCategory(String categoryID) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.deleteCategory(categoryID);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
    ref.invalidate(activeSearchFiltersNotifierProvider);
    ref.invalidate(advancedSearchDataNotifierProvider);
    ref.invalidate(isAdvancedFilterNotifierProvider);
    ref.invalidate(currentInventoryPage);
    ref.invalidate(advancedInventoryNotifierProvider);
  }
}
