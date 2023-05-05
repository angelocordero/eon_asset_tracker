import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/item_model.dart';

class ItemInfoDisplay extends ConsumerWidget {
  const ItemInfoDisplay({super.key});

  static final TextEditingController _descriptionController =
      TextEditingController();

  static final TextEditingController _remarksController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Item? selectedItem = ref.watch(selectedItemProvider);

    _descriptionController.text = selectedItem?.description ?? '';
    _remarksController.text = selectedItem?.remarks ?? '';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 5,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              enabled: false,
              maxLines: 10,
              minLines: 10,
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Item Description',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _descriptionController,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 5,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              enabled: false,
              maxLines: 10,
              minLines: 10,
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                labelText: 'Remarks',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _remarksController,
            ),
          ),
          const VerticalDivider(
            width: 40,
          ),
          Flexible(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('QR Code'),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.zoom_in,
                      ),
                      label: const Text('Enlarge QR Code'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.print),
                      label: const Text('Print QR Code'),
                    ),
                  ],
                ),
                const Spacer(),
                selectedItem == null
                    ? Container()
                    : QrImage(
                        data: selectedItem.assetID,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 40,
          ),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Item Status'),
                const Divider(),
                Text(selectedItem?.status.name ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
