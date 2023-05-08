import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
              QrImage(
                size: 500,
                data: assetID,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                embeddedImage: const AssetImage('assets/logo.jpg'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(80, 80),
                ),
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
    );
  }
}
