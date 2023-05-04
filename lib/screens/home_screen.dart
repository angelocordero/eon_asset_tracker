import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/tabs/tab_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static final _controller = SidebarXController(selectedIndex: 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eon Asset Tracker | ${ref.watch(appbarTitleProvider)}'),
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
            items: [
              SidebarXItem(
                icon: Icons.home,
                label: 'Home',
                onTap: () {
                  ref.read(appbarTitleProvider.notifier).state = 'Home';
                },
              ),
              SidebarXItem(
                icon: Icons.inventory_2,
                label: 'Inventory',
                onTap: () {
                  ref.read(appbarTitleProvider.notifier).state = 'Inventory';
                },
              ),
            ],
          ),
          Expanded(
            child: TabSwitcher(controller: _controller),
          )
        ],
      ),
    );
  }
}
