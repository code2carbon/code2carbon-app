import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class TrajectoryChartWidget extends StatelessWidget {
  final double baselineTons;
  final double totalSavingsTons;

  const TrajectoryChartWidget({
    super.key,
    required this.baselineTons,
    required this.totalSavingsTons,
  });

  @override
  Widget build(BuildContext context) {
    // Generate 10-year projection data (2026 to 2036)
    final List<FlSpot> bauSpots = [];
    final List<FlSpot> decarbSpots = [];

    double currentBau = baselineTons > 0 ? baselineTons : 82.5;
    bauSpots.add(FlSpot(0, currentBau));
    decarbSpots.add(FlSpot(0, currentBau));

    double maxY = currentBau;

    for (int t = 1; t <= 10; t++) {
      currentBau = currentBau * 1.015; // +1.5% YoY BAU expansion
      bauSpots.add(FlSpot(t.toDouble(), currentBau));

      final phaseFactor = (t * 0.2).clamp(0.0, 1.0);
      final currentDec = (currentBau - (totalSavingsTons * phaseFactor)).clamp(0.0, double.infinity);
      decarbSpots.add(FlSpot(t.toDouble(), currentDec));

      if (currentBau > maxY) maxY = currentBau;
    }

    final chartMaxY = (maxY * 1.15).ceilToDouble();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.show_chart_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('10-Year Decarbonization Trajectory',
                        style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                    Text('Simulated pathway vs. Business-As-Usual (BAU) (+1.5%/yr)',
                        style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Chart Display
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 10,
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
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                        final year = 2026 + value.toInt();
                        return Text(
                          '$year',
                          style: AppTypography.bodySmall.copyWith(fontSize: 10),
                        );
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
                        final year = 2026 + spot.x.toInt();
                        final isBau = spot.barIndex == 0;
                        return LineTooltipItem(
                          isBau
                              ? 'BAU ($year): ${spot.y.toStringAsFixed(1)}t'
                              : 'Decarb ($year): ${spot.y.toStringAsFixed(1)}t',
                          TextStyle(
                            color: isBau ? Colors.redAccent : AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // BAU Curve (Dashed Red)
                  LineChartBarData(
                    spots: bauSpots,
                    isCurved: true,
                    dashArray: [6, 4],
                    color: const Color(0xFFEF4444),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                  // Decarbonization Curve (Solid Emerald Green with Gradient Area)
                  LineChartBarData(
                    spots: decarbSpots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.3),
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

          const SizedBox(height: 16),
          // Chart Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _LegendItem(
                label: 'BAU baseline (+1.5%/yr)',
                color: const Color(0xFFEF4444),
                isDashed: true,
              ),
              _LegendItem(
                label: 'Projected Decarbonization',
                color: AppColors.primary,
                isDashed: false,
              ),
              _LegendItem(
                label: 'Net-Zero Benchmark',
                color: AppColors.textMuted,
                isDashed: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDashed;

  const _LegendItem({
    required this.label,
    required this.color,
    required this.isDashed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
