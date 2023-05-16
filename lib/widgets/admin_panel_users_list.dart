import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

class AdminPanelUsersList extends ConsumerWidget {
  const AdminPanelUsersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<User> users = ref.watch(adminPanelProvider.select((value) => List<User>.from(value['users']!)));


    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(
                  label: Text('U S E R   I D'),
                ),
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
                      selected: ref.watch(adminPanelSelectedUserProvider) == e,
                      onSelectChanged: (value) {
                        ref.read(adminPanelSelectedUserProvider.notifier).state = e;
                      },
                      cells: [
                        DataCell(
                          Text(e.userID),
                        ),
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
          ),
        ),
      ],
    );
  }
}
