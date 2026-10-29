import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/dashboard_data_model.dart';

class ScopeDonutChart extends StatefulWidget {
  final DashboardDataModel data;

  const ScopeDonutChart({
    super.key,
    required this.data,
  });

  @override
  State<ScopeDonutChart> createState() => _ScopeDonutChartState();
}

class _ScopeDonutChartState extends State<ScopeDonutChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.data.scope1Tons +
        widget.data.scope2Tons +
        widget.data.scope3Tons;
    final s1Pct = total > 0 ? (widget.data.scope1Tons / total * 100) : 0.0;
    final s2Pct = total > 0 ? (widget.data.scope2Tons / total * 100) : 0.0;
    final s3Pct = total > 0 ? (widget.data.scope3Tons / total * 100) : 0.0;

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
                  Text('Emissions by Scope',
                      style: AppTypography.titleMedium.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text('Share of total gross tCO₂e',
                      style: AppTypography.bodySmall),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'GHG Protocol',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Donut Chart + Center Total
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 3,
                    centerSpaceRadius: 54,
                    sections: [
                      // Scope 1
                      PieChartSectionData(
                        color: AppColors.scope1,
                        value: widget.data.scope1Tons,
                        title: '${s1Pct.toStringAsFixed(0)}%',
                        radius: _touchedIndex == 0 ? 32 : 26,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Scope 2
                      PieChartSectionData(
                        color: AppColors.scope2,
                        value: widget.data.scope2Tons,
                        title: '${s2Pct.toStringAsFixed(0)}%',
                        radius: _touchedIndex == 1 ? 32 : 26,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Scope 3
                      PieChartSectionData(
                        color: AppColors.scope3,
                        value: widget.data.scope3Tons,
                        title: '${s3Pct.toStringAsFixed(0)}%',
                        radius: _touchedIndex == 2 ? 32 : 26,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${total.toStringAsFixed(0)}t',
                      style: AppTypography.displaySmall.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.dark,
                      ),
                    ),
                    Text(
                      'Gross Total',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Interactive Scope Legend
          Row(
            children: [
              Expanded(
                child: _ScopeLegendTile(
                  name: 'Scope 1',
                  desc: 'Direct',
                  tons: widget.data.scope1Tons,
                  pct: s1Pct,
                  color: AppColors.scope1,
                  isSelected: _touchedIndex == 0,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ScopeLegendTile(
                  name: 'Scope 2',
                  desc: 'Electricity',
                  tons: widget.data.scope2Tons,
                  pct: s2Pct,
                  color: AppColors.scope2,
                  isSelected: _touchedIndex == 1,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ScopeLegendTile(
                  name: 'Scope 3',
                  desc: 'Indirect',
                  tons: widget.data.scope3Tons,
                  pct: s3Pct,
                  color: AppColors.scope3,
                  isSelected: _touchedIndex == 2,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class _ScopeLegendTile extends StatelessWidget {
  final String name;
  final String desc;
  final double tons;
  final double pct;
  final Color color;
  final bool isSelected;

  const _ScopeLegendTile({
    required this.name,
    required this.desc,
    required this.tons,
    required this.pct,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${tons.toStringAsFixed(0)} t (${pct.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Text(
            desc,
            style: AppTypography.bodySmall.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        ],
      ),
    );
  }
}
