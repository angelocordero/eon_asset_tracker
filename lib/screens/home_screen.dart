import 'package:eon_asset_tracker/tabs/tab_switcher.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _controller = SidebarXController(selectedIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eon Asset Tracker'),
      ),
      body: Row(
        children: [
          SidebarX(
            controller: _controller,
            theme: const SidebarXTheme(
              itemPadding: EdgeInsets.only(top: 20, left: 10, right: 10),
              selectedItemPadding:
                  EdgeInsets.only(top: 20, left: 10, right: 10),
              itemTextPadding: EdgeInsets.only(left: 20),
              selectedItemTextPadding: EdgeInsets.only(left: 20),
              textStyle: TextStyle(color: Colors.grey),
              selectedTextStyle: TextStyle(color: Colors.white),
              selectedIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.grey),
            ),
            extendedTheme: const SidebarXTheme(
              width: 200,
              textStyle: TextStyle(color: Colors.grey),
              selectedTextStyle: TextStyle(color: Colors.white),
              margin: EdgeInsets.only(right: 10),
              selectedIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.grey),
            ),
            footerDivider: const Divider(),
            items: const [
              SidebarXItem(icon: Icons.home, label: 'Home'),
              SidebarXItem(icon: Icons.inventory_2, label: 'Inventory'),
            ],
          ),
          Expanded(
              child: TabSwitcher(
            controller: _controller,
          ))
        ],
      ),
    );
  }
}
