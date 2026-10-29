import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class MethodologyTimelineWidget extends StatefulWidget {
  const MethodologyTimelineWidget({super.key});

  @override
  State<MethodologyTimelineWidget> createState() =>
      _MethodologyTimelineWidgetState();
}

class _MethodologyTimelineWidgetState extends State<MethodologyTimelineWidget> {
  int _activeStep = 0;

  static const _steps = [
    (
      stepNum: '01',
      title: 'Data Collection',
      shortDesc: 'User logs energy bills, transport fuels, and paper usage.',
      deepTitle: 'Data Collection Deep-Dive',
      deepDesc:
          'Our engine ingests localized consumption variables via verified audit ledgers. Users log parameters including transport fuel, electricity meter units, LPG cylinders, and paper consumption. High security standards guarantee data is processed securely.',
      icon: Icons.cloud_download_outlined,
    ),
    (
      stepNum: '02',
      title: 'Emission Calculation',
      shortDesc: 'Maps inputs against verified carbon coefficients (CEA, IPCC).',
      deepTitle: 'Emission Calculation Factors',
      deepDesc:
          'The mathematical engine maps activity data against national conversion datasets. It multiplies transport kilometers by fuel coefficients, converts grid kWh using CEA baseline factors (0.792 kg/kWh), and computes LPG and paper footprints.',
      icon: Icons.calculate_outlined,
    ),
    (
      stepNum: '03',
      title: 'Statistical Analysis',
      shortDesc: 'Categorizes into Scopes 1, 2, 3 and ranks emission hotspots.',
      deepTitle: 'Statistical Breakdown & Benchmarks',
      deepDesc:
          'Calculated outputs are categorized strictly into Scope 1 (Direct), Scope 2 (Purchased energy), and Scope 3 (Value chain). Data aggregates into institutional per-capita and per-area intensity benchmarks.',
      icon: Icons.pie_chart_outline_rounded,
    ),
    (
      stepNum: '04',
      title: 'Actionable Reporting',
      shortDesc: 'Produces ISO 14064-1 reports and Net-Zero roadmaps.',
      deepTitle: 'Actionable Sustainability Plans',
      deepDesc:
          'The platform generates audit-ready accreditation reports aligned to ISO 14064-1 and the GHG Protocol. Context-aware engineering interventions guide institutions toward Net-Zero carbon neutrality.',
      icon: Icons.assignment_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final current = _steps[_activeStep];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header — left aligned, on surface
        Text('OUR PROCESS', style: AppTypography.sectionBadge),
        const SizedBox(height: 6),
        Text(
          'Assessment Methodology',
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
          'Code2Carbon leverages environmental frameworks established by the IPCC, GHG Protocol, and ISO 14064-1 to guarantee analytical fidelity.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // 4 Interactive Step Buttons
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _steps.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final s = _steps[index];
            final isActive = _activeStep == index;

            return InkWell(
              onTap: () {
                setState(() {
                  _activeStep = index;
                });
              },
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.07)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.lightBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          s.stepNum,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isActive ? Colors.white : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.title,
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 14.5,
                              color: isActive ? AppColors.primaryDark : AppColors.dark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s.shortDesc,
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isActive
                          ? Icons.check_circle_rounded
                          : Icons.chevron_right_rounded,
                      color: isActive ? AppColors.primary : AppColors.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            );

          },
        ),

        const SizedBox(height: 16),

        // Animated Deep Dive Detail Card
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey<int>(_activeStep),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLight.withOpacity(0.7),
                  AppColors.secondaryLight.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(current.icon, color: AppColors.primaryDark, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        current.deepTitle,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  current.deepDesc,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkSlate,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
