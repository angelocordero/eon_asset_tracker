import 'package:eon_asset_tracker/tabs/inventory_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

import 'dashboard_tab.dart';

class TabSwitcher extends ConsumerWidget {
  const TabSwitcher({super.key, required this.controller});

  final SidebarXController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return const DashboardTab();
          case 1:
            return const InventoryTab();
          default:
            return Container();
        }
      },
    );
  }
}
