import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/dashboard_data_model.dart';

class MonthlyTrendChart extends StatelessWidget {
  final List<MonthlyEmissionPoint> monthlyData;

  const MonthlyTrendChart({
    super.key,
    required this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    double maxVal = 0;
    double sum = 0;

    for (int i = 0; i < monthlyData.length; i++) {
      final y = monthlyData[i].emissionsTons;
      spots.add(FlSpot(i.toDouble(), y));
      if (y > maxVal) maxVal = y;
      sum += y;
    }

    final avg = monthlyData.isNotEmpty ? (sum / monthlyData.length) : 0.0;
    final chartMaxY = (maxVal * 1.25).ceilToDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly Emissions Trend',
                      style: AppTypography.titleMedium.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text('Rolling 12 months • tCO₂e/mo',
                      style: AppTypography.bodySmall),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.show_chart_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Avg ${avg.toStringAsFixed(1)}t',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Chart Display
          SizedBox(
            height: 190,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (monthlyData.length - 1).toDouble(),
                minY: 0,
                maxY: chartMaxY > 0 ? chartMaxY : 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: chartMaxY / 4 > 0 ? chartMaxY / 4 : 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.borderDivider,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      interval: chartMaxY / 4 > 0 ? chartMaxY / 4 : 25,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}t',
                          style: AppTypography.bodySmall.copyWith(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < monthlyData.length) {
                          return Text(
                            monthlyData[idx].month,
                            style: AppTypography.bodySmall
                                .copyWith(fontSize: 10),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final idx = spot.x.toInt();
                        final month = idx < monthlyData.length
                            ? monthlyData[idx].month
                            : '';
                        return LineTooltipItem(
                          '$month: ${spot.y.toStringAsFixed(1)} tCO₂e',
                          const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primary,
                    barWidth: 3.2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3.5,
                          color: Colors.white,
                          strokeWidth: 2.2,
                          strokeColor: AppColors.primary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.28),
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 10,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Seasonal variance reflects campus academic session heating/cooling cycles',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
