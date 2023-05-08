import 'package:eon_asset_tracker/core/providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardDepartmentChart extends ConsumerWidget {
  const DashboardDepartmentChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> departmentsData =
        ref.watch(departmentsDataProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Items per Department',
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
                titlesData: titlesData(departmentsData),
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
        max = elementCount * 1.3;
      }
    }

    return max.toDouble();
  }

  Widget getTitles(double value, TitleMeta meta,
      List<Map<String, dynamic>> departmentsData) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String departmentName = departmentsData[value.toInt()]['departmentName'];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(departmentName, style: style),
    );
  }

  FlTitlesData titlesData(List<Map<String, dynamic>> departmentsData) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (double value, TitleMeta meta) {
            return getTitles(value, meta, departmentsData);
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

  List<BarChartGroupData> barGroups(
      List<Map<String, dynamic>> departmentsData) {
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
