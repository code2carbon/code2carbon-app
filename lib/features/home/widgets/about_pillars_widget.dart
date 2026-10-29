import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class AboutPillarsWidget extends StatelessWidget {
  const AboutPillarsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const pillars = [
      (
        title: 'Institutional Data Collection',
        description:
            'Centralize electricity, diesel, petrol, LPG, water, paper, waste, refrigerant, and business-travel data from every department in one secure ledger.',
        icon: Icons.layers_outlined,
        color: AppColors.primary,
        bgColor: AppColors.primaryLight,
      ),
      (
        title: 'Standards-Based Assessment',
        description:
            'Convert activity data into precise CO₂e emissions using ISO 14064-1, GHG Protocol, IPCC guidelines, and government-published emission factors.',
        icon: Icons.track_changes_rounded,
        color: AppColors.secondary,
        bgColor: AppColors.secondaryLight,
      ),
      (
        title: 'Actionable Reporting',
        description:
            'Generate scope-wise carbon inventories, executive dashboards, and audit-ready reports aligned to net-zero and sustainability disclosure frameworks.',
        icon: Icons.insights_rounded,
        color: AppColors.offset,
        bgColor: AppColors.offsetLight,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header — no box
        Text('UNDERSTANDING EMISSIONS', style: AppTypography.sectionBadge),
        const SizedBox(height: 6),
        Text(
          'Why Code2Carbon?',
          style: AppTypography.displayMedium.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Code2Carbon enables educational institutions to measure, analyze, and report greenhouse gas emissions in accordance with internationally recognized standards.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // Pillars — horizontal icon + text, no outer box, just a left-accent line
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pillars.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final p = pillars[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: p.bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(p.icon, color: p.color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        p.title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        p.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
