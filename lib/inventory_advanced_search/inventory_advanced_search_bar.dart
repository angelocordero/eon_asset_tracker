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
    return _clearFilterChip();
  }

  Directionality _clearFilterChip() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ActionChip(
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
      ),
    );
  }
}

