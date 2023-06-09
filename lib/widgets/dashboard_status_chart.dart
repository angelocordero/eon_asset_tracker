import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../notifiers/dashboard_notifiers.dart';
import 'dashboard_chart_legend.dart';

class DashboardStatusChart extends ConsumerWidget {
  const DashboardStatusChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(dashboardStatusProvider).when(
          data: (statusData) {
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
                        'S T A T U S   B R E A K D O W N',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ..._legend(),
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
                          sections: _data(statusData),
                          centerSpaceRadius: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ],
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

  List<PieChartSectionData> _data(Map<String, int> statusData) {
    int totalItems = 0;

    for (int element in statusData.values) {
      totalItems += element;
    }

    return statusData.entries.map((entry) {
      double percent = (entry.value / totalItems) * 100;
      String percentage = '${percent.toStringAsFixed(0)} %';

      Color color;

      switch (entry.key) {
        case 'Good':
          color = sampleColors[9];
          break;
        case 'Defective':
          color = sampleColors[4];
          break;
        default:
          color = sampleColors[10];
      }

      return PieChartSectionData(
        badgeWidget: Text(
          '$percentage\n${entry.value} items',
          textAlign: TextAlign.center,
        ),
        badgePositionPercentageOffset: 2,
        value: entry.value.toDouble(),
        title: '',
        color: color,
      );
    }).toList();
  }

  List<Widget> _legend() {
    return ItemStatus.values.map((entry) {
      Color color;

      switch (entry) {
        case ItemStatus.Good:
          color = sampleColors[9];
          break;
        case ItemStatus.Defective:
          color = sampleColors[4];
          break;
        default:
          color = sampleColors[10];
      }

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: DashboardChartLegend(
          color: color,
          text: entry.name,
          size: 20,
        ),
      );
    }).toList();
  }
}
