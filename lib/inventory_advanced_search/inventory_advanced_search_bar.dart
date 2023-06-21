import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/inventory_advanced_search/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_popup.dart';
import 'slide_route.dart';

class AdvancedInventorySearch extends ConsumerWidget {
  const AdvancedInventorySearch({super.key});
  static final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isFiltering = ref.watch(isAdvancedFilterNotifierProvider);

    return Expanded(
      child: Row(
        children: [
          _searchButton(context, ref),
          const SizedBox(width: 50),
          if (isFiltering) const Text('F I L T E R S :'),
          if (isFiltering) Expanded(child: _filterChips(ref)),
        ],
      ),
    );
  }

  Widget _searchButton(BuildContext context, WidgetRef ref) {
    return ActionChip(
      backgroundColor: ref.watch(isAdvancedFilterNotifierProvider) ? Colors.blue : null,
      label: const Text('Search'),
      avatar: const Icon(Icons.search),
      onPressed: () {
        Navigator.push(
          context,
          SlideRoute(
            builder: (context) {
              return const SearchPopup();
            },
          ),
        );
      },
    );
  }

  Widget _filterChips(WidgetRef ref) {
    List<InventorySearchFilter> filters = ref.watch(activeSearchFiltersNotifierProvider);

    Map<String, dynamic> searchData = ref.watch(advancedSearchDataNotifierProvider);

    return ScrollbarTheme(
      data: const ScrollbarThemeData(
        trackVisibility: MaterialStatePropertyAll<bool>(false),
      ),
      child: Scrollbar(
        controller: scrollController,
        scrollbarOrientation: ScrollbarOrientation.top,
        child: ListView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          children: filters.map((e) {
            if ((e == InventorySearchFilter.department && searchData.containsValue('hotdog')) ||
                (e == InventorySearchFilter.status && searchData.containsValue(AdvancedSearchStatusEnum.All))) {
              return Container();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Chip(label: Text(inventoryFilterEnumToDisplayString(e))),
            );
          }).toList(),
        ),
      ),
    );
  }
}
