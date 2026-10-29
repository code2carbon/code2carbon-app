import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/dashboard_data_model.dart';
import '../widgets/dashboard_kpi_grid.dart';
import '../widgets/emission_sources_breakdown.dart';
import '../widgets/esg_audit_simulator_sheet.dart';
import '../widgets/intensity_benchmark_card.dart';
import '../widgets/monthly_trend_chart.dart';
import '../widgets/scope_donut_chart.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToCalculator;

  const DashboardScreen({
    super.key,
    required this.onNavigateToCalculator,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardDataModel _data;

  @override
  void initState() {
    super.initState();
    _data = DashboardDataModel.defaultData;
  }

  void _showEsgAuditModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EsgAuditSimulatorSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section Header
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('LIVE INVENTORY DASHBOARD',
                          style: AppTypography.sectionBadge),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Carbon Intelligence Hub',
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
                    'Real-time overview of institutional greenhouse gas accounting aligned with ISO 14064-1 and GHG Protocol Standards.',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // KPI Grid with Net Footprint Hero
            DashboardKpiGrid(data: _data),
            const SizedBox(height: 20),

            // Scope Share Donut & Breakdown
            ScopeDonutChart(data: _data),
            const SizedBox(height: 20),

            // Monthly Trend Chart
            MonthlyTrendChart(monthlyData: _data.monthlyTrends),
            const SizedBox(height: 20),

            // Emission Sources Breakdown
            EmissionSourcesBreakdown(categories: _data.categories),
            const SizedBox(height: 20),

            // Intensity Benchmarks & ESG Simulator Button
            IntensityBenchmarkCard(
              data: _data,
              onOpenAuditSimulator: _showEsgAuditModal,
              onOpenCalculator: widget.onNavigateToCalculator,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
