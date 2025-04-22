import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/energy_data.dart';

class EnergyGraph extends StatelessWidget {
  final dynamic data;
  final bool isDevice;

  const EnergyGraph({
    super.key,
    required this.data,
    this.isDevice = false,
  });

  List<FlSpot> _getSpots() {
    if (data == null || (data is List && data.isEmpty)) {
      return [];
    }

    if (data is List<EnergyData>) {
      return List.generate(
        data.length,
        (index) => FlSpot(
          data[index].timestamp.hour.toDouble(),
          data[index].consumption,
        ),
      );
    }

    if (data is List<Map<String, dynamic>>) {
      return List.generate(
        data.length,
        (index) => FlSpot(
          index.toDouble(),
          data[index]['consumption']?.toDouble() ?? 0.0,
        ),
      );
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final spots = _getSpots();
    
    if (spots.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No energy data available',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 153),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()} kWh',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 2 == 0) {
                    return Text(
                      '${value.toInt()}:00',
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 51),
              ),
            ),
          ],
          minX: 0,
          maxX: 23,
          minY: 0,
          maxY: spots.isEmpty
              ? 10
              : spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2,
        ),
      ),
    );
  }
} 