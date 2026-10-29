import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import 'package:intl/intl.dart';

class ForecastKpiRow extends StatelessWidget {
  final double reductionTons;
  final double reductionPct;
  final double totalCapEx;
  final double avgPayback;

  const ForecastKpiRow({
    super.key,
    required this.reductionTons,
    required this.reductionPct,
    required this.totalCapEx,
    required this.avgPayback,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.compactSimpleCurrency();

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.36,
      children: [
        _KpiCard(
          label: 'Simulated Reduction',
          value: reductionTons.toStringAsFixed(2),
          unit: 'tCO₂e/yr',
          color: AppColors.primary,
        ),
        _KpiCard(
          label: 'Reduction Share',
          value: reductionPct.toStringAsFixed(0),
          unit: '%',
          color: AppColors.primary,
        ),
        _KpiCard(
          label: 'Cumulative CapEx',
          value: currency.format(totalCapEx),
          unit: 'USD',
          color: AppColors.dark,
        ),
        _KpiCard(
          label: 'Est. Payback Period',
          value: avgPayback.toStringAsFixed(1),
          unit: 'years',
          color: AppColors.secondary,
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: AppTypography.displaySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

