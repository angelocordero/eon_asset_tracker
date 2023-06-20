import 'package:eon_asset_tracker/core/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifiers.g.dart';

@Riverpod(keepAlive: true)
class ActiveSearchFiltersNotifier extends _$ActiveSearchFiltersNotifier {
  @override
  List<InventorySearchFilter> build() {
    return [
      InventorySearchFilter.department,
      InventorySearchFilter.status,
    ];
  }

  void enable(InventorySearchFilter filter) {
    state.add(filter);

    state = List.from(state);
  }

  void disable(InventorySearchFilter filter) {
    state.remove(filter);

    state = List.from(state);
  }
}

@Riverpod(keepAlive: true)
class IsAdvancedFilterNotifier extends _$IsAdvancedFilterNotifier {
  @override
  bool build() {
    return false;
  }

  void activate() {
    state = true;
  }
}

@Riverpod(keepAlive: true)
class AdvancedSearchDataNotifier extends _$AdvancedSearchDataNotifier {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void setState(Map<String, dynamic> input) {
    state = Map.from(input);
  }
}
