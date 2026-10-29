import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class StandardsGridWidget extends StatelessWidget {
  const StandardsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const standards = [
      (
        title: 'ISO 14064-1',
        subtitle: 'GHG quantification & reporting standard',
        icon: Icons.verified_user_outlined,
        color: AppColors.primary,
      ),
      (
        title: 'GHG Protocol',
        subtitle: 'Corporate accounting & reporting standard',
        icon: Icons.public_rounded,
        color: Color(0xFF0D9488),
      ),
      (
        title: 'IPCC Guidelines',
        subtitle: 'National GHG inventory methodologies',
        icon: Icons.analytics_outlined,
        color: AppColors.secondary,
      ),
      (
        title: 'Govt. Factors',
        subtitle: 'Regionally verified CO₂e coefficients',
        icon: Icons.assignment_turned_in_outlined,
        color: Color(0xFF7C3AED),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Label
        Center(
          child: Text(
            'BUILT ON INTERNATIONALLY TRUSTED STANDARDS',
            style: AppTypography.sectionBadge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 18),

        // Standards in a responsive 2-column grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.12,
          ),
          itemCount: standards.length,

          itemBuilder: (context, index) {
            final item = standards[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: AppTypography.titleMedium.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
