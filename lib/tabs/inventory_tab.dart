import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/screens/add_item_screen.dart';
import 'package:flutter/material.dart';

class InventoryTab extends StatelessWidget {
  const InventoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomRoute(
                      builder: (context) {
                        return const AddItemScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.blueGrey,
              child: const Center(
                child: Text('inventory table'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
