import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class CapabilitiesGridWidget extends StatelessWidget {
  const CapabilitiesGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const capabilities = [
      (
        title: 'Scope 1, 2 & 3 Tracking',
        desc:
            'Track direct combustion, purchased energy, and value-chain emissions across all GHG categories.',
        icon: Icons.timeline_rounded,
        color: AppColors.primary,
      ),
      (
        title: 'Automated Inventory',
        desc:
            'Activity data automatically flows into scope-classified inventories — no spreadsheets.',
        icon: Icons.auto_mode_rounded,
        color: AppColors.secondary,
      ),
      (
        title: 'Dashboard Analytics',
        desc:
            'Real-time KPIs, scope-wise breakdowns, monthly trends, and comparative benchmarking.',
        icon: Icons.bar_chart_rounded,
        color: AppColors.offset,
      ),
      (
        title: 'Report Generation',
        desc:
            'Generate audit-ready CO₂e reports aligned to ISO 14064-1 and ESG disclosure frameworks.',
        icon: Icons.description_outlined,
        color: Color(0xFF0D9488),
      ),
      (
        title: 'AI Recommendations',
        desc:
            'Context-aware reduction insights surfacing highest-impact decarbonization opportunities.',
        icon: Icons.lightbulb_outline_rounded,
        color: Color(0xFFD97706),
      ),
      (
        title: 'Institutional Governance',
        desc:
            'Role-based access, department-wise data ownership, and secure multi-campus audit trails.',
        icon: Icons.shield_outlined,
        color: Color(0xFF7C3AED),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label — on surface, no box
        Text('PLATFORM CAPABILITIES', style: AppTypography.sectionBadge),
        const SizedBox(height: 6),
        Text(
          'Full Lifecycle Accounting',
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
          'Six purpose-built modules that cover the full lifecycle — from data ingestion to standards-aligned reporting.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // Capabilities — shadow-only cards, no harsh borders
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.84,
          ),
          itemCount: capabilities.length,

          itemBuilder: (context, index) {
            final c = capabilities[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: c.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(c.icon, color: c.color, size: 22),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    c.title,
                    style: AppTypography.titleMedium.copyWith(fontSize: 13.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      c.desc,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
