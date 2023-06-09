import 'package:eon_asset_tracker/widgets/dashboard_category_chart.dart';
import 'package:eon_asset_tracker/widgets/dashboard_status_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../widgets/dashboard_department_chart.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10),
      child: Visibility(
        visible: ref.watch(dashboardDataProvider.notifier).isLoading,
        replacement: ListView(
          children: [
            AspectRatio(
              aspectRatio: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 3,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'T O T A L   I T E M S',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Tooltip(
                                  message: 'Refresh Page',
                                  child: IconButton.outlined(
                                    onPressed: () async {
                                      await ref.read(dashboardDataProvider.notifier).refresh();
                                    },
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  ref.watch(dashboardDataProvider).totalItems.toString(),
                                  style: const TextStyle(fontSize: 50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Flexible(
                    flex: 7,
                    child: Card(
                      child: DashboardDepartmentChart(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const AspectRatio(
              aspectRatio: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 3,
                    child: Card(
                      child: DashboardStatusChart(),
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Card(
                      child: DashboardCategoryChart(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
