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
                      columnSpacing: 10,
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'U S E R   N A M E',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'P R O P E R T Y',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'D E P A R T M E N T',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: users
                          .map(
                            (e) => DataRow(
                              selected: ref.watch(adminPanelSelectedUserProvider) == e,
                              onSelectChanged: (value) {
                                ref.read(adminPanelSelectedUserProvider.notifier).state = e;
                              },
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      if (e.isAdmin)
                                        const Icon(
                                          Icons.verified,
                                          size: 20,
                                        ),
                                      const SizedBox(width: 10),
                                      Text(
                                        e.username,
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    e.property.propertyName,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    e.department.departmentName,
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
