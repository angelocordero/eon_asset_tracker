import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../notifiers/admin_panel_users_notifier.dart';

class AdminPanelUsersList extends ConsumerWidget {
  const AdminPanelUsersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ref.watch(adminPanelUsersNotifierProvider).when(
                data: (users) {
                  return SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(
                          label: Text('U S E R   N A M E'),
                        ),
                        DataColumn(
                          label: Text('D E P A R T M E N T'),
                        ),
                        DataColumn(
                          label: Text('S T A T U S'),
                        ),
                      ],
                      rows: users
                          .map(
                            (e) => DataRow(
                              selected:
                                  ref.watch(adminPanelSelectedUserProvider) ==
                                      e,
                              onSelectChanged: (value) {
                                ref
                                    .read(
                                        adminPanelSelectedUserProvider.notifier)
                                    .state = e;
                              },
                              cells: [
                                DataCell(
                                  Text(e.username),
                                ),
                                DataCell(
                                  Text(e.department?.departmentName ?? ''),
                                ),
                                DataCell(
                                  e.isAdmin
                                      ? const Chip(
                                          side: BorderSide(color: Colors.grey),
                                          label: Text('A D M I N'),
                                        )
                                      : const Chip(
                                          side: BorderSide(color: Colors.grey),
                                          label: Text('U S E R'),
                                        ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
                error: (e, st) => Center(
                  child: Text(
                    e.toString(),
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        ),
      ],
    );
  }
}
