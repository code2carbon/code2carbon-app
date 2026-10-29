import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../widgets/hero_banner_widget.dart';
import '../widgets/standards_grid_widget.dart';
import '../widgets/about_pillars_widget.dart';
import '../widgets/stats_overview_widget.dart';
import '../widgets/methodology_timeline_widget.dart';
import '../widgets/capabilities_grid_widget.dart';
import '../widgets/governance_security_widget.dart';
import '../widgets/footer_widget.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToCalculator;

  const HomeScreen({
    super.key,
    required this.onNavigateToCalculator,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _methodologyKey = GlobalKey();

  void _scrollToMethodology() {
    final context = _methodologyKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero (no card, raw surface) ──────────────────────────────
          HeroBannerWidget(
            onExplore: widget.onNavigateToCalculator,
            onMethodology: _scrollToMethodology,
          ),

          _SectionDivider(),

          // ── Standards Grid ───────────────────────────────────────────
          const StandardsGridWidget(),

          _SectionDivider(),

          // ── Why Code2Carbon pillars ──────────────────────────────────
          const AboutPillarsWidget(),

          _SectionDivider(),

          // ── Stats dark-green banner ──────────────────────────────────
          const StatsOverviewWidget(),

          _SectionDivider(),

          // ── Methodology interactive timeline ─────────────────────────
          Container(
            key: _methodologyKey,
            child: const MethodologyTimelineWidget(),
          ),

          _SectionDivider(),

          // ── Capabilities grid ────────────────────────────────────────
          const CapabilitiesGridWidget(),

          _SectionDivider(),

          // ── Trust & Governance ───────────────────────────────────────
          const GovernanceSecurityWidget(),

          _SectionDivider(),

          // ── Footer ───────────────────────────────────────────────────
          const FooterWidget(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// A subtle horizontal rule that separates sections on the surface,
/// replacing large SizedBox gaps to give more visual rhythm.
class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.borderSubtle.withValues(alpha: 0.5),
      ),
    );
  }
}
