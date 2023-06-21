import 'package:eon_asset_tracker/notifiers/theme_notifier.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    ThemeMode themeMode = ref.watch(themeNotifierProvider).valueOrNull ?? ThemeMode.light;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 5,
            child: TextField(
              style: TextStyle(color: themeMode == ThemeMode.light ? Colors.black : Colors.white),
              readOnly: true,
              maxLines: 10,
              minLines: 10,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: themeMode == ThemeMode.light ? Colors.black : Colors.white)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: themeMode == ThemeMode.light ? Colors.black : Colors.white)),
                labelStyle: TextStyle(color: themeMode == ThemeMode.light ? Colors.black : Colors.white),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: '  I T E M   D E S C R I P T I O N  ',
                hintText: 'No description',
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
              style: TextStyle(color: themeMode == ThemeMode.light ? Colors.black : Colors.white),
              readOnly: true,
              maxLines: 10,
              minLines: 10,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: themeMode == ThemeMode.light ? Colors.black : Colors.white)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: themeMode == ThemeMode.light ? Colors.black : Colors.white)),
                labelStyle: TextStyle(color: themeMode == ThemeMode.light ? Colors.black : Colors.white),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: '  R E M A R K S  ',
                hintText: 'No remarks',
              ),
              controller: _remarksController,
            ),
          ),
          const VerticalDivider(
            width: 40,
          ),
          Flexible(
            flex: 2,
            child: selectedItem == null
                ? const Center(
                    child: Text('No QR Code'),
                  )
                : qrCodeImage(context, selectedItem.assetID, themeMode),
          ),
          const VerticalDivider(
            width: 40,
          ),
          const Flexible(
            flex: 7,
            child: PaginationNavigator(),
          ),
        ],
      ),
    );
  }

  Widget qrCodeImage(BuildContext context, String assetID, ThemeMode themeMode) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CustomRoute(
            builder: (context) {
              return QRCodeDisplay(
                assetID: assetID,
                themeMode: themeMode,
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            color: Colors.blue,
            child: Container(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Hero(
                tag: assetID,
                child: generateQRImage(assetID: assetID, themeMode: themeMode),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            height: 40,
            width: 40,
            child: Container(
              color: Colors.blue,
              child: const Center(
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
