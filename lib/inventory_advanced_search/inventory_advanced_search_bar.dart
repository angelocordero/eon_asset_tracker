import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/inventory_advanced_search/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_popup.dart';
import 'slide_route.dart';

class AdvancedInventorySearch extends ConsumerStatefulWidget {
  const AdvancedInventorySearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdvancedInventorySearchState();
}

class _AdvancedInventorySearchState extends ConsumerState<AdvancedInventorySearch> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFiltering = ref.watch(isAdvancedFilterNotifierProvider);

    return Row(
      children: [
        _searchButton(),
        const SizedBox(width: 50),
        if (isFiltering) const Text('F I L T E R S :'),
        if (isFiltering) ..._filterChips(),
      ],
    );
  }

  Widget _searchButton() {
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

  List<Widget> _filterChips() {
    List<InventorySearchFilter> filters = ref.watch(activeSearchFiltersNotifierProvider);

    Map<String, dynamic> searchData = ref.watch(advancedSearchDataNotifierProvider);

    return filters.map((e) {
      if ((e == InventorySearchFilter.department && searchData.containsValue('hotdog')) ||
          (e == InventorySearchFilter.status && searchData.containsValue(AdvancedSearchStatusEnum.All))) {
        return Container();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Chip(label: Text(inventoryFilterEnumToDisplayString(e))),
      );
    }).toList();
  }
}
