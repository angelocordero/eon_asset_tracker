import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/item_model.dart';

class ItemInfoDisplay extends ConsumerWidget {
  const ItemInfoDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Item? selectedItem = ref.watch(selectedItemProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Item Description'),
                const Divider(),
                Text(selectedItem == null
                    ? ''
                    : selectedItem.description ?? 'Item has no description.'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Item Status'),
                const Divider(),
                Text(selectedItem?.status.name ?? ''),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Remarks'),
                const Divider(),
                Text(selectedItem?.remarks ?? ''),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('QR Code'),
                selectedItem == null
                    ? Container()
                    : QrImage(
                        data: selectedItem.assetID,
                        backgroundColor: Colors.white,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
