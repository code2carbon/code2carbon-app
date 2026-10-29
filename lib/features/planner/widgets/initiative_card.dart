import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/initiative_model.dart';
import 'package:intl/intl.dart';

class InitiativeCard extends StatelessWidget {
  final InitiativeModel initiative;
  final ValueChanged<bool> onToggle;

  const InitiativeCard({
    super.key,
    required this.initiative,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return InkWell(
      onTap: () => onToggle(!initiative.isSelected),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: initiative.isSelected
                ? AppColors.primary
                : AppColors.borderSubtle,
            width: initiative.isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            if (initiative.isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Checkbox
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: initiative.isSelected
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: initiative.isSelected
                            ? AppColors.primary
                            : AppColors.textMuted,
                        width: 1.8,
                      ),
                    ),
                    child: initiative.isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              initiative.title,
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 15,
                                color: initiative.isSelected
                                    ? AppColors.dark
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: initiative.scopeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              initiative.scopeLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: initiative.scopeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        initiative.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // Metrics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetaItem(
                  label: 'Est. CapEx:',
                  value: currencyFormat.format(initiative.capEx),
                ),
                _MetaItem(
                  label: 'Payback:',
                  value: '~${initiative.paybackYears.toStringAsFixed(1)} Yrs',
                ),
                _MetaItem(
                  label: 'Impact:',
                  value: initiative.impactText,
                  isHighlight: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _MetaItem({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: isHighlight ? AppColors.primary : AppColors.dark,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
