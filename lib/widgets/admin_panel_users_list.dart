// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/providers.dart';
import '../models/user_model.dart';

final usersProvider = Provider<List<User>>((ref) {
  return List<User>.from((ref.watch(adminPanelProvider)['users'])?.toList() ?? []);
});

class AdminPanelUsersList extends ConsumerWidget {
  const AdminPanelUsersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
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
              rows: ref
                  .watch(usersProvider)
                  .map(
                    (e) => DataRow(
                      selected: ref.watch(adminPanelSelectedUserProvider) == e,
                      onSelectChanged: (value) {
                        ref.read(adminPanelSelectedUserProvider.notifier).state = e;
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
          ),
        ),
      ],
    );
  }
}
