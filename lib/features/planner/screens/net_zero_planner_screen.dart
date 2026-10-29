import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/initiative_model.dart';
import '../widgets/forecast_kpi_row.dart';
import '../widgets/initiative_card.dart';
import '../widgets/trajectory_chart_widget.dart';

class NetZeroPlannerScreen extends StatefulWidget {
  final double currentBaselineTons;

  const NetZeroPlannerScreen({
    super.key,
    this.currentBaselineTons = 82.5,
  });

  @override
  State<NetZeroPlannerScreen> createState() => _NetZeroPlannerScreenState();
}

class _NetZeroPlannerScreenState extends State<NetZeroPlannerScreen> {
  late List<InitiativeModel> _initiatives;

  @override
  void initState() {
    super.initState();
    _initiatives = InitiativeModel.defaultInitiatives;
  }

  void _toggleInitiative(int index, bool value) {
    setState(() {
      _initiatives[index].isSelected = value;
    });
  }

  void _selectAll(bool select) {
    setState(() {
      for (var init in _initiatives) {
        init.isSelected = select;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Compute current planner metrics
    double totalSavings = 0;
    double totalCapEx = 0;
    double weightedPaybackSum = 0;

    for (var init in _initiatives) {
      if (init.isSelected) {
        totalSavings += init.savingsTons;
        totalCapEx += init.capEx;
        weightedPaybackSum += init.capEx * init.paybackYears;
      }
    }

    final avgPayback = totalCapEx > 0 ? (weightedPaybackSum / totalCapEx) : 0.0;
    final baseline = widget.currentBaselineTons > 0 ? widget.currentBaselineTons : 82.5;
    final reductionPct = (totalSavings / baseline) * 100;

    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Text('DECARBONIZATION PATHWAY', style: AppTypography.sectionBadge),
                  const SizedBox(height: 6),
                  Text(
                    'Net-Zero Transition Hub',
                    style: AppTypography.displayMedium.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Simulate your path to sustainability. Toggle specific green initiatives to see their direct CapEx cost, payback time, and aggregate impact on your 10-year carbon emissions forecast.',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live KPI Cards
            ForecastKpiRow(
              reductionTons: totalSavings,
              reductionPct: reductionPct.clamp(0.0, 100.0),
              totalCapEx: totalCapEx,
              avgPayback: avgPayback,
            ),
            const SizedBox(height: 20),

            // 10-Year Trajectory Chart
            TrajectoryChartWidget(
              baselineTons: baseline,
              totalSavingsTons: totalSavings,
            ),
            const SizedBox(height: 24),

            // Section Subtitle & Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Mitigation Initiatives',
                  style: AppTypography.titleMedium.copyWith(fontSize: 16),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _selectAll(true),
                      child: const Text('All'),
                    ),
                    TextButton(
                      onPressed: () => _selectAll(false),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List of Initiative Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _initiatives.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return InitiativeCard(
                  initiative: _initiatives[index],
                  onToggle: (val) => _toggleInitiative(index, val),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
