import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../models/dashboard_model.dart';

final sortedCategoryProvider = Provider<CategoriesDashboardData>((ref) {
  CategoriesDashboardData categories = ref.watch(dashboardDataProvider).categoriesDashbordData;

  categories.sort((a, b) {
    int aCount = a['count'];
    int bCount = b['count'];

    return bCount.compareTo(aCount);
  });

  return categories;
});

final maxXProvider = Provider<double>((ref) {
  CategoriesDashboardData categories = ref.watch(dashboardDataProvider).categoriesDashbordData;

  List<int> counts = categories.map((e) => e['count'] as int).toList();

  return counts.reduce((value, element) => value > element ? value : element).toDouble() * 1.1;
});

class DashboardCategoryChart extends ConsumerWidget {
  const DashboardCategoryChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CategoriesDashboardData categories = ref.watch(sortedCategoryProvider);
    double max = ref.watch(maxXProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'I T E M S   P E R   C A T E G O R Y',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            ...categories.map((category) {
              return Card(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        category['categoryName'],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          category['count'].toString(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 15,
                          thumbShape: SliderComponentShape.noOverlay,
                          disabledActiveTrackColor: sampleColors[2],
                          disabledInactiveTrackColor: Colors.transparent,
                        ),
                        child: Slider(
                          value: (category['count'] as int).toDouble(),
                          max: max,
                          onChanged: null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
