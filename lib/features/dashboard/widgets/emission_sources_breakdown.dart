import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/dashboard_data_model.dart';

class EmissionSourcesBreakdown extends StatelessWidget {
  final List<EmissionCategoryItem> categories;

  const EmissionSourcesBreakdown({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text('Emission Hotspots',
                      style: AppTypography.titleMedium.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text('Institutional carbon intensity ranked by source',
                      style: AppTypography.bodySmall),
                ],
              ),
              const Icon(Icons.local_fire_department_outlined,
                  color: Color(0xFFEF4444)),
            ],
          ),
          const SizedBox(height: 18),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _HotspotItem(cat: cat);
            },
          ),
        ],
      ),
    );
  }
}

class _HotspotItem extends StatelessWidget {
  final EmissionCategoryItem cat;

  const _HotspotItem({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cat.scopeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(cat.icon, size: 16, color: cat.scopeColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.name,
                    style: AppTypography.labelLarge.copyWith(fontSize: 13),
                  ),
                  Text(
                    '${cat.tons.toStringAsFixed(0)} tCO₂e • ${cat.percentage.toStringAsFixed(0)}% of total',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: cat.scopeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                cat.scope,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: cat.scopeColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (cat.percentage / 100.0).clamp(0.0, 1.0),
            backgroundColor: AppColors.lightBg,
            valueColor: AlwaysStoppedAnimation<Color>(cat.scopeColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
