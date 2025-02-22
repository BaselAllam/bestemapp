import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class AdChart extends StatefulWidget {
  const AdChart({super.key});

  @override
  State<AdChart> createState() => _AdChartState();
}

class _AdChartState extends State<AdChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.whiteColor
      ),
      child: BarChart(
        BarChartData(
          barGroups: _getBarGroups(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text("Day ${value.toInt() + 1}");
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: true),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    final data = [
      [5, 8],
      [7, 6],
      [4, 9],
      [6, 5],
      [8, 7],
    ];

    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: data[index][0].toDouble(), color: Colors.blue, width: 10),
          BarChartRodData(toY: data[index][1].toDouble(), color: Colors.red, width: 10),
        ],
        barsSpace: 4,
      );
    });
  }
}