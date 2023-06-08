// Flutter imports:
import 'package:eon_asset_tracker/models/dashboard_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/providers.dart';

final sortedDepartmentsProvider = Provider<DepartmentsDashboardData>((ref) {
  DepartmentsDashboardData departments = ref.watch(dashboardDataProvider).departmentsDashboardData;

  departments.sort((a, b) {
    int aCount = a['count'];
    int bCount = b['count'];

    return bCount.compareTo(aCount);
  });

  return departments;
});

class DashboardDepartmentChart extends ConsumerWidget {
  const DashboardDepartmentChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DepartmentsDashboardData departments = ref.watch(sortedDepartmentsProvider);

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
                titlesData: titlesData(List<String>.from(departments.map((e) => e['departmentName']))),
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
  }

  double maxY(DepartmentsDashboardData departmentsData) {
    List<int> counts = departmentsData.map((e) => e['count'] as int).toList();

    return counts.reduce((value, element) => value > element ? value : element).toDouble() * 1.25;
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

  List<BarChartGroupData> barGroups(List<Map<String, dynamic>> departmentsData) {
    return departmentsData.map((entry) {
      return BarChartGroupData(
        x: entry['index'],
        barRods: [
          BarChartRodData(
            toY: (entry['count'] as int).toDouble(),
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}
