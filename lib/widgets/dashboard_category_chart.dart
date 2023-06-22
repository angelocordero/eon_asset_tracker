import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../notifiers/dashboard_notifiers.dart';

class DashboardCategoryChart extends ConsumerWidget {
  const DashboardCategoryChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(dashboardCategoriesNotifierProvider)
      .when(
        data: (Map<String, int> categoriesData) {
          double max = categoriesData.values
                  .reduce((value, element) => value > element ? value : element)
                  .toDouble() *
              1.1;

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
                  ...categoriesData.entries.map((category) {
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
                              category.key,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                category.value.toString(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 15,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackShape: const RectangularSliderTrackShape(),
                                trackHeight: 15,
                                thumbShape: SliderComponentShape.noOverlay,
                                disabledActiveTrackColor: sampleColors[2],
                                disabledInactiveTrackColor: Colors.transparent,
                              ),
                              child: Slider(
                                value: category.value.toDouble(),
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
        },
        error: (e, st) => Center(
          child: Text(
            e.toString(),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      );
}
