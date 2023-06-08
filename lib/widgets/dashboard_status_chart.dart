// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/constants.dart';
import '../core/providers.dart';
import '../models/dashboard_model.dart';
import 'dashboard_chart_legend.dart';

class DashboardStatusChart extends ConsumerWidget {
  const DashboardStatusChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DashboardData dashboardData = ref.watch(dashboardDataProvider);

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
              ..._legend(dashboardData.statusDashboardData),
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
                  sections: _data(dashboardData),
                  centerSpaceRadius: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _data(DashboardData dashboardData) {
    return dashboardData.statusDashboardData.entries.map((entry) {
      double percent = (entry.value / dashboardData.totalItems) * 100;
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

  List<Widget> _legend(Map<String, int> statusData) {
    return statusData.entries.map((entry) {
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

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: DashboardChartLegend(
          color: color,
          text: entry.key,
          size: 20,
        ),
      );
    }).toList();
  }
}
