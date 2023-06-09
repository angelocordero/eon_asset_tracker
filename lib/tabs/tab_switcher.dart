import 'package:flutter/material.dart';

import 'package:sidebarx/sidebarx.dart';

import 'admin_panel_tab.dart';
import 'dashboard_tab.dart';
import 'inventory_tab.dart';

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
            return const DashboardTab();
          case 1:
            return const InventoryTab();
          case 2:
            return const AdminPanelTab();
          default:
            return Container();
        }
      },
    );
  }
}
