import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';

class PaginationNavigator extends ConsumerWidget {
  const PaginationNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int inventoryItemCount = ref.watch(dashboardDataProvider).totalItems;

    int pages = (inventoryItemCount / itemsPerPage).ceil();

    List<ElevatedButton> buttons = List.generate(
      pages,
      (index) => ElevatedButton(
        onPressed: () {},
        child: Text(
          (index + 1).toString(),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        children: buttons,
      ),
    );
  }
}
