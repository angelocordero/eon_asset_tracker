import 'package:eon_asset_tracker/tabs/inventory_tab.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class TabSwitcher extends StatelessWidget {
  const TabSwitcher({super.key, required this.controller});

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return Container();
          case 1:
            return const InventoryTab();
          default:
            return Container();
        }
      },
    );
  }
}
