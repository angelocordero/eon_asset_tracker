import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/dashboard_notifiers.dart';

// Project imports:

class DashboardDepartmentChart extends ConsumerWidget {
  const DashboardDepartmentChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(dashboardDepartmentsNotifierProvider).when(
          data: (departments) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'I T E M S   P E R   D E P A R T M E N T',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AspectRatio(
                    aspectRatio: 3.5,
                    child: BarChart(
                      BarChartData(
                        maxY: maxY(departments),
                        titlesData: titlesData(departments.keys.toList()),
                        borderData: FlBorderData(show: true),
                        barGroups: barGroups(departments),
                        gridData: FlGridData(show: true),
                        alignment: BarChartAlignment.spaceAround,
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

  double maxY(Map<String, int> departmentsData) {
    return departmentsData.values
            .reduce((value, element) => value > element ? value : element)
            .toDouble() *
        1.25;
  }

  Widget getTitles(double value, TitleMeta meta, List<String> departmentNames) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String departmentName = departmentNames[value.toInt()];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(departmentName, style: style),
    );
  }

  FlTitlesData titlesData(List<String> departmentNames) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (double value, TitleMeta meta) {
            return getTitles(value, meta, departmentNames);
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  List<BarChartGroupData> barGroups(Map<String, dynamic> departments) {
    int index = 0;

    return departments.entries.map((entry) {
      BarChartGroupData buffer = BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (entry.value as int).toDouble(),
          ),
        ],
        showingTooltipIndicators: [0],
      );

      index++;

      return buffer;
    }).toList();
  }
}
