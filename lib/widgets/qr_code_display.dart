// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../core/utils.dart';

class QRCodeDisplay extends StatelessWidget {
  const QRCodeDisplay({super.key, required this.assetID});

  final String assetID;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
          Navigator.pop(context); // Pop the screen when Escape is pressed
        }
      },
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 500,
                  height: 500,
                  child: generateQRImage(assetID: assetID, size: 500),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  assetID,
                  style: const TextStyle(fontSize: 50),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
