import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../inventory_advanced_search/advanced_inventory_notifier.dart';
import '../inventory_advanced_search/notifiers.dart';
import '../models/property_model.dart';
import 'admin_panel_users_notifier.dart';

part 'properties_notifier.g.dart';

@Riverpod(keepAlive: true)
class PropertiesNotifier extends _$PropertiesNotifier {
  @override
  FutureOr<List<Property>> build() async {
    state = const AsyncLoading();
    return await DatabaseAPI.getProperties();
  }

  Future<void> addProperty(String propertyName) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.addProperty(propertyName);
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

  Future<void> editProperty(Property property) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.editProperty(property);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
    ref.invalidate(activeSearchFiltersNotifierProvider);
    ref.invalidate(advancedSearchDataNotifierProvider);
    ref.invalidate(isAdvancedFilterNotifierProvider);
    ref.invalidate(currentInventoryPage);
    ref.invalidate(advancedInventoryNotifierProvider);
    ref.invalidate(adminPanelUsersNotifierProvider);
  }

  Future<void> deleteProperty(String propertyID) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.deleteProperty(propertyID);
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
