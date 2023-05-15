import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/tabs/tab_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.controller});

  final SidebarXController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eon Asset Tracker | ${ref.watch(appbarTitleProvider)}'),
        actions: [
          Center(
            child: Row(
              children: [
                const Text(
                  'Logged in as: ',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  ref.watch(userProvider)?.username ?? '',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Row(
        children: [
          SidebarX(
            controller: controller,
            theme: const SidebarXTheme(
              itemPadding: EdgeInsets.only(top: 20, left: 10, right: 10),
              selectedItemPadding: EdgeInsets.only(top: 20, left: 10, right: 10),
              itemTextPadding: EdgeInsets.only(left: 20),
              selectedItemTextPadding: EdgeInsets.only(left: 20),
              textStyle: TextStyle(color: Colors.grey),
              selectedTextStyle: TextStyle(color: Colors.white),
              selectedIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.grey),
            ),
            extendedTheme: const SidebarXTheme(
              width: 180,
              textStyle: TextStyle(color: Colors.grey),
              selectedTextStyle: TextStyle(color: Colors.white),
              margin: EdgeInsets.only(right: 10),
              selectedIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.grey),
            ),
            footerBuilder: (context, extended) {
              return Column(
                children: [
                  extended
                      ? ListTile(
                          title: const SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text('L O G   O U T'),
                          ),
                          leading: const Icon(Icons.logout),
                          onTap: () {
                            showConfirmLogoutDialog(context);
                          },
                        )
                      : IconButton(
                          onPressed: () {
                            showConfirmLogoutDialog(context);
                          },
                          icon: const Icon(Icons.logout),
                        ),
                  const Divider(),
                ],
              );
            },
            items: [
              SidebarXItem(
                icon: Icons.home,
                label: 'H O M E',
                onTap: () {
                  ref.read(appbarTitleProvider.notifier).state = 'Home';
                },
              ),
              SidebarXItem(
                icon: Icons.inventory_2,
                label: 'I N V E N T O R Y',
                onTap: () {
                  ref.read(appbarTitleProvider.notifier).state = 'Inventory';
                },
              ),
              if (ref.watch(userProvider)?.isAdmin ?? false)
                SidebarXItem(
                  icon: Icons.admin_panel_settings,
                  label: 'A D M I N',
                  onTap: () {
                    ref.read(appbarTitleProvider.notifier).state = 'Admin Panel';
                  },
                ),
            ],
          ),
          Expanded(
            child: TabSwitcher(controller: controller),
          )
        ],
      ),
    );
  }

  Future<dynamic> showConfirmLogoutDialog(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
