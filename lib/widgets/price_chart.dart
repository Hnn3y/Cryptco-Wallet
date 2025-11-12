import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChart extends StatelessWidget {
  final List<double> data;
  final Color color;

  const PriceChart({
    super.key,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final spots = List.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), data[index]),
    );

    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);

    // --- FIX FOR ZERO-RANGE ERROR ---
    double chartMinY = minY;
    double chartMaxY = maxY;
    double interval = 0.0;
    
    // Check if all data points are identical (minY == maxY)
    if (minY == maxY) {
      // Set a small default range for the chart boundaries
      chartMinY = minY - 1.0; 
      chartMaxY = maxY + 1.0;
      interval = 0.5; // A safe, non-zero interval
    } else {
      // Use original calculations for varying data
      final padding = (maxY - minY) * 0.1;
      chartMinY = minY - padding;
      chartMaxY = maxY + padding;
      interval = (chartMaxY - chartMinY) / 4;
    }
    // ---------------------------------

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          // Use the safe calculated interval
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[800]!,
              strokeWidth: 0.5,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        // Use the safe calculated minY/maxY
        minY: chartMinY,
        maxY: chartMaxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            // The previous fix is kept here:
getTooltipColor: (LineBarSpot touchedSpot) => const Color(0xFF1A1F3A),
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                  '\$${barSpot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}