import 'package:eon_asset_tracker/core/utils.dart';
import 'package:flutter/material.dart';

class QRCodeDisplay extends StatelessWidget {
  const QRCodeDisplay({super.key, required this.assetID});

  final String assetID;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              generateQRImage(assetID: assetID, size: 500),
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
    );
  }
}
