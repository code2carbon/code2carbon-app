import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class GovernanceSecurityWidget extends StatelessWidget {
  const GovernanceSecurityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        title: 'Institution Data Security',
        desc:
            'All data encrypted in transit (TLS 1.3) and at rest (AES-256). Segmented by tenant with zero cross-institution exposure.',
        icon: Icons.lock_outline_rounded,
      ),
      (
        title: 'Role-Based Access Control',
        desc:
            'Granular permissions for administrators, sustainability officers, department heads, and auditors.',
        icon: Icons.admin_panel_settings_outlined,
      ),
      (
        title: 'Encrypted Records',
        desc:
            'Utility bills, invoices, and activity logs are stored as encrypted records within your compliance boundary.',
        icon: Icons.receipt_long_outlined,
      ),
      (
        title: 'Full Audit Trail',
        desc:
            'Every data entry, edit, calculation, and report export is logged with timestamp and user attribution.',
        icon: Icons.history_edu_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header — directly on the surface, no wrapping box
        Text('TRUST & SECURITY', style: AppTypography.sectionBadge),
        const SizedBox(height: 6),
        Text(
          'Institution-Grade Data Governance',
          style: AppTypography.displayMedium.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF0D9488)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 20),

        // Items — flat icon rows on the surface
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(
            height: 22,
            color: AppColors.borderSubtle.withValues(alpha: 0.7),
          ),
          itemBuilder: (context, index) {
            final it = items[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(it.icon, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        it.title,
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        it.desc,
                        style: AppTypography.bodySmall.copyWith(
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
