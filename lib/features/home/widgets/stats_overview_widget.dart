import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class StatsOverviewWidget extends StatelessWidget {
  const StatsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const stats = [
      (value: '3', label: 'Emission Scopes Covered'),
      (value: '20+', label: 'Emission Categories'),
      (value: '100%', label: 'Standards Based'),
      (value: '24/7', label: 'Data Access'),
    ];

    // Full-width gradient band — no border-radius card in a card
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF065F46), Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'PLATFORM AT A GLANCE',
            style: AppTypography.sectionBadge.copyWith(
              color: const Color(0xFF6EE7B7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Built for institutional scale',
            style: AppTypography.displaySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 4 stat items in a 2x2 grid, no inner bordered box
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.3,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final s = stats[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        s.value,
                        style: AppTypography.displayMedium.copyWith(
                          color: const Color(0xFF6EE7B7),
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      s.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}
