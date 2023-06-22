import 'package:eon_asset_tracker/notifiers/properties_notifier.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/dashboard_notifiers.dart';
import '../widgets/dashboard_category_chart.dart';
import '../widgets/dashboard_department_chart.dart';
import '../widgets/dashboard_status_chart.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(propertiesNotifierProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10),
      child: ListView(
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
                                    ref.invalidate(dashboardCategoriesProvider);
                                    ref.invalidate(dashboardDepartmentsProvider);
                                    ref.invalidate(dashboardStatusProvider);
                                  },
                                  icon: const Icon(Icons.refresh),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Consumer(builder: (BuildContext context, WidgetRef ref, _) {
                                Map<String, int> data = ref.watch(dashboardStatusProvider).valueOrNull ?? {};
                                int total = 0;

                                for (int value in data.values) {
                                  total += value;
                                }

                                return Text(
                                  total.toString(),
                                  style: const TextStyle(fontSize: 50),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Flexible(
                  flex: 6,
                  child: Card(
                    child: DashboardStatusChart(),
                  ),
                ),
              ],
            ),
          ),
          const AspectRatio(
            aspectRatio: 2.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 1,
                  child: Card(
                    child: DashboardDepartmentChart(),
                  ),
                ),
              ],
            ),
          ),
          const DashboardCategoryChart(),
        ],
      ),
    );
  }
}
