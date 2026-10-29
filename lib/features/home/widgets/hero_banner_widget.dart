import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import 'eco_scene_graphic.dart';

class HeroBannerWidget extends StatelessWidget {
  final VoidCallback onExplore;
  final VoidCallback onMethodology;

  const HeroBannerWidget({
    super.key,
    required this.onExplore,
    required this.onMethodology,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Status Pill — sits directly on the surface
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'Institutional Sustainability Platform',
                style: AppTypography.sectionBadge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Hero Title — large, bold, no box
        RichText(
          text: TextSpan(
            style: AppTypography.displayLarge.copyWith(
              fontSize: 28,
              letterSpacing: -0.6,
              height: 1.2,
            ),
            children: const [
              TextSpan(text: 'Measure, Report &\n'),
              TextSpan(
                text: 'Reduce Carbon Emissions',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Subtitle
        Text(
          'Code2Carbon helps educational institutions measure, analyze, and report Scope 1, 2, and 3 greenhouse gas emissions using internationally recognized methodologies.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 20),

        // Animated Eco Scene — no box, just the graphic
        const EcoSceneGraphic(),
        const SizedBox(height: 20),

        // Standard badges row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _HeroBadge(label: 'ISO 14064-1'),
            _HeroBadge(label: 'GHG Protocol'),
            _HeroBadge(label: 'Scope 1 · 2 · 3'),
            _HeroBadge(label: 'CO₂e Reporting'),
          ],
        ),
        const SizedBox(height: 24),

        // CTA Buttons — Responsive layout
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 340;
            final exploreBtn = ElevatedButton.icon(
              onPressed: onExplore,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text(
                'Explore Platform',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );

            final methodologyBtn = OutlinedButton(
              onPressed: onMethodology,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Methodology',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  exploreBtn,
                  const SizedBox(height: 10),
                  methodologyBtn,
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: exploreBtn,
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: methodologyBtn,
                ),
              ],
            );
          },
        ),
      ],
    );

  }
}

class _HeroBadge extends StatelessWidget {
  final String label;

  const _HeroBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.primary,
            size: 13,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.dark,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
