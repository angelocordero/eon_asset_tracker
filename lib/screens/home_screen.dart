import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

import '../core/constants.dart';
import '../core/providers.dart';
import '../notifiers/theme_notifier.dart';
import '../tabs/tab_switcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SidebarXController controller = ref.watch(sidebarControllerProvider);
    ThemeMode themeMode = ref.watch(themeNotifierProvider).valueOrNull ?? ThemeMode.light;

    return Scaffold(
      appBar: AppBar(
        title: Text('EON ASSET TRACKER  |  ${ref.watch(appbarTitleProvider)}'),
        actions: [
          Center(
            child: Row(
              children: [
                Text(
                  'Logged in as: ',
                  style: TextStyle(color: themeMode == ThemeMode.light ? Colors.grey[800] : Colors.grey),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  ref.watch(userProvider)?.username ?? '',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 30,
                  child: ToggleButtons(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.blue[700],
                    fillColor: themeMode == ThemeMode.light ? Colors.blue[900] : Colors.blue[200],
                    isSelected: themeMode == ThemeMode.light ? [true, false] : [false, true],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          if (themeMode == ThemeMode.light) return;
                        case 1:
                          if (themeMode == ThemeMode.dark) return;
                      }
                      ref.read(themeNotifierProvider.notifier).toggleTheme();
                    },
                    children: const [
                      Icon(
                        Icons.light_mode,
                        color: Colors.yellow,
                        size: 15,
                      ),
                      Icon(
                        Icons.dark_mode,
                        color: Colors.indigo,
                        size: 15,
                      ),
                    ],
                  ),
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
            theme: SidebarXTheme(
              itemPadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              selectedItemPadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              itemTextPadding: const EdgeInsets.only(left: 20),
              selectedItemTextPadding: const EdgeInsets.only(left: 20),
              textStyle: TextStyle(color: themeMode == ThemeMode.light ? null : Colors.grey),
              selectedTextStyle: TextStyle(color: themeMode == ThemeMode.light ? Colors.blue : Colors.white),
              selectedIconTheme: IconThemeData(color: themeMode == ThemeMode.light ? Colors.blue : Colors.white),
              iconTheme: IconThemeData(color: themeMode == ThemeMode.light ? null : Colors.grey),
            ),
            extendedTheme: SidebarXTheme(
              width: 200,
              textStyle: TextStyle(color: themeMode == ThemeMode.light ? null : Colors.grey),
              selectedTextStyle: TextStyle(color: themeMode == ThemeMode.light ? Colors.blue : Colors.white),
              margin: const EdgeInsets.only(right: 10),
              selectedIconTheme: IconThemeData(color: themeMode == ThemeMode.light ? Colors.blue : Colors.white),
              iconTheme: IconThemeData(color: themeMode == ThemeMode.light ? null : Colors.grey),
            ),
            footerBuilder: (context, extended) {
              return Column(
                children: [
                  extended
                      ? ListTile(
                          title: const SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              'L O G   O U T',
                              style: TextStyle(fontSize: 12),
                            ),
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
                  ref.read(appbarTitleProvider.notifier).state = 'HOME';
                },
              ),
              SidebarXItem(
                icon: Icons.inventory_2,
                label: 'I N V E N T O R Y',
                // label: 'INVENTORY',
                onTap: () {
                  ref.read(appbarTitleProvider.notifier).state = 'INVENTORY';
                  ref.read(searchFilterProvider.notifier).state = InventorySearchFilter.assetID;
                },
              ),
              if (ref.watch(userProvider)?.isAdmin ?? false)
                SidebarXItem(
                  icon: Icons.admin_panel_settings,
                  label: 'A D M I N',
                  onTap: () {
                    ref.read(appbarTitleProvider.notifier).state = 'ADMIN PANEL';
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
