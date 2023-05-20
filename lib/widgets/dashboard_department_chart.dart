// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/providers.dart';
import '../models/department_model.dart';

class DashboardDepartmentChart extends ConsumerWidget {
  const DashboardDepartmentChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> departmentsData = ref.watch(dashboardDataProvider).departmentsDashboardData;
    List<Department> departments = ref.watch(departmentsProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                maxY: maxY(departmentsData),
                titlesData: titlesData(departments),
                borderData: FlBorderData(show: true),
                barGroups: barGroups(departmentsData),
                gridData: FlGridData(show: true),
                alignment: BarChartAlignment.spaceAround,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double maxY(List<Map<String, dynamic>> departmentsData) {
    double max = 0;

    for (var element in departmentsData) {
      double elementCount = (element['count'] as int).toDouble();

      if (elementCount > max) {
        max = elementCount * 1.5;
      }
    }

    return max.toDouble();
  }

  Widget getTitles(double value, TitleMeta meta, List<Department> departments) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String departmentName = departments[value.toInt()].departmentName;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(departmentName, style: style),
    );
  }

  FlTitlesData titlesData(List<Department> departments) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (double value, TitleMeta meta) {
            return getTitles(value, meta, departments);
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
