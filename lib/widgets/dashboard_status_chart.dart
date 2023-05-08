import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_chart_legend.dart';

class DashboardStatusChart extends ConsumerWidget {
  const DashboardStatusChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, int> statusData = ref.watch(statusDataProvider);
    int totalItems = ref.watch(totalItemsProvider);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 30,
              ),
              ..._legend(statusData),
            ],
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.5,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 10,
                  sections: _data(statusData, totalItems),
                  centerSpaceRadius: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _data(Map<String, int> statusData, int totalItems) {
    return statusData.entries.map((entry) {
      String percentage =
          '${(entry.value / totalItems * 100).toStringAsFixed(0)}%';

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: percentage,
        color: entry.key == 'Good' ? sampleColors[9] : sampleColors[4],
      );
    }).toList();
  }

  List<Widget> _legend(Map<String, int> statusData) {
    return statusData.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: DashboardChartLegend(
          color: entry.key == 'Good' ? sampleColors[9] : sampleColors[4],
          text: '${entry.key} - ${entry.value.toString()}',
          size: 20,
        ),
      );
    }).toList();
  }
}
