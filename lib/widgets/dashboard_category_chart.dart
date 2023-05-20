// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/providers.dart';
import '../models/category_model.dart';

class DashboardCategoryChart extends ConsumerWidget {
  const DashboardCategoryChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> categoriesData = ref.watch(dashboardDataProvider).categoriesDashbordData;

    List<ItemCategory> categories = ref.watch(categoriesProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'I T E M S   P E R   C A T E G O R Y',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          AspectRatio(
            aspectRatio: 3.5,
            child: BarChart(
              BarChartData(
                maxY: maxY(categoriesData),
                titlesData: titlesData(categories),
                borderData: FlBorderData(show: true),
                barGroups: barGroups(categoriesData),
                gridData: FlGridData(show: true),
                alignment: BarChartAlignment.spaceAround,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double maxY(List<Map<String, dynamic>> categoriesData) {
    double max = 0;

    for (var element in categoriesData) {
      double elementCount = (element['count'] as int).toDouble();

      if (elementCount > max) {
        max = elementCount * 1.5;
      }
    }

    return max.toDouble();
  }

  Widget getTitles(double value, TitleMeta meta, List<ItemCategory> categories) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String categoryName = categories[value.toInt()].categoryName;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(categoryName, style: style),
    );
  }

  FlTitlesData titlesData(List<ItemCategory> categories) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (double value, TitleMeta meta) {
            return getTitles(value, meta, categories);
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

  List<BarChartGroupData> barGroups(List<Map<String, dynamic>> categoriesData) {
    return categoriesData.map((entry) {
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
