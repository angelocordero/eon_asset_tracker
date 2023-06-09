import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';

class InventoryCheckbox extends ConsumerWidget {
  const InventoryCheckbox({
    super.key,
    required this.assetID,
  });

  final String assetID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Checkbox(
      value: ref.watch(checkedItemProvider).contains(assetID),
      onChanged: (checked) {
        if (checked == null) return;

        List<String> buffer = ref.read(checkedItemProvider);

        if (checked) {
          buffer.add(assetID);
        } else {
          buffer.remove(assetID);
        }
        ref.read(checkedItemProvider.notifier).state = buffer.toList();
      },
    );
  }
}
