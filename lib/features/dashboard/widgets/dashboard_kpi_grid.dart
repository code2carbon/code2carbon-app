import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/dashboard_data_model.dart';

class DashboardKpiGrid extends StatelessWidget {
  final DashboardDataModel data;

  const DashboardKpiGrid({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Net Footprint Hero Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF10B981)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'NET CARBON FOOTPRINT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'FY 2025-26',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    data.totalNetTons.toStringAsFixed(1),
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'tCO₂e / yr',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(color: Colors.white.withValues(alpha: 0.25), height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeroMetricSub(
                    label: 'Gross Emissions',
                    value: '${data.totalGrossTons.toStringAsFixed(0)} t',
                  ),
                  _HeroMetricSub(
                    label: 'Clean Offsets',
                    value: '-${data.totalOffsetsTons.toStringAsFixed(1)} t',
                    isOffset: true,
                  ),
                  _HeroMetricSub(
                    label: 'Audit Status',
                    value: 'Compliant',
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Scope 1, 2, 3 Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.25,
          children: [

            _KpiTile(
              title: 'Gross CO₂e',
              value: '${data.totalGrossTons.toStringAsFixed(0)} t',
              yoyPct: data.grossYoyPct,
              badgeColor: AppColors.primary,
              icon: Icons.cloud_outlined,
            ),
            _KpiTile(
              title: 'Scope 1 (Direct)',
              value: '${data.scope1Tons.toStringAsFixed(0)} t',
              yoyPct: data.scope1YoyPct,
              badgeColor: AppColors.scope1,
              icon: Icons.local_fire_department_outlined,
            ),
            _KpiTile(
              title: 'Scope 2 (Energy)',
              value: '${data.scope2Tons.toStringAsFixed(0)} t',
              yoyPct: data.scope2YoyPct,
              badgeColor: AppColors.scope2,
              icon: Icons.bolt_outlined,
            ),
            _KpiTile(
              title: 'Scope 3 (Value Chain)',
              value: '${data.scope3Tons.toStringAsFixed(0)} t',
              yoyPct: data.scope3YoyPct,
              badgeColor: AppColors.scope3,
              icon: Icons.sync_alt_rounded,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroMetricSub extends StatelessWidget {
  final String label;
  final String value;
  final bool isOffset;

  const _HeroMetricSub({
    required this.label,
    required this.value,
    this.isOffset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isOffset ? const Color(0xFF6EE7B7) : Colors.white,
          ),
        ),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String title;
  final String value;
  final double yoyPct;
  final Color badgeColor;
  final IconData icon;

  const _KpiTile({
    required this.title,
    required this.value,
    required this.yoyPct,
    required this.badgeColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDecrease = yoyPct <= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(icon, size: 16, color: badgeColor),
            ],
          ),
          Text(
            value,
            style: AppTypography.displaySmall.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
            ),
          ),
          Row(
            children: [
              Icon(
                isDecrease
                    ? Icons.trending_down_rounded
                    : Icons.trending_up_rounded,
                size: 14,
                color: isDecrease
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 4),
              Text(
                '${yoyPct.abs().toStringAsFixed(1)}% vs LY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDecrease
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
