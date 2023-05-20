// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/custom_route.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../models/item_model.dart';
import 'pagination_navigator.dart';
import 'qr_code_display.dart';

class ItemInfoDisplay extends ConsumerWidget {
  const ItemInfoDisplay({super.key});

  static final TextEditingController _descriptionController = TextEditingController();

  static final TextEditingController _remarksController = TextEditingController();

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
              readOnly: true,
              maxLines: 10,
              minLines: 10,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                labelText: '  I T E M   D E S C R I P T I O N  ',
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
              readOnly: true,
              maxLines: 10,
              minLines: 10,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                labelText: '  R E M A R K S  ',
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
            child: selectedItem == null
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('QR Code'),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CustomRoute(
                                  builder: (context) {
                                    return QRCodeDisplay(assetID: selectedItem.assetID);
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.zoom_in,
                            ),
                            label: const Text('Enlarge QR Code'),
                          ),
                        ],
                      ),
                      const Spacer(),
                      generateQRImage(assetID: selectedItem.assetID),
                    ],
                  ),
          ),
          const VerticalDivider(
            width: 40,
          ),
          const Flexible(
            flex: 5,
            child: PaginationNavigator(),
          ),
        ],
      ),
    );
  }
}
