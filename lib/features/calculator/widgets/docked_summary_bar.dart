import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../services/calculator_engine.dart';

class DockedSummaryBar extends StatelessWidget {
  final VoidCallback onOpenFinalTab;
  final VoidCallback onExportCsv;

  const DockedSummaryBar({
    super.key,
    required this.onOpenFinalTab,
    required this.onExportCsv,
  });

  @override
  Widget build(BuildContext context) {
    final engine = CalculatorEngine();

    return ListenableBuilder(
      listenable: engine,
      builder: (context, _) {
        final gross = engine.grossTons;
        final offsets = engine.totalCleanOffsetsTons;
        final net = engine.netTons;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.borderSubtle.withValues(alpha: 0.8), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Left: emissions summary
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _MiniTag(
                            label: 'Gross ${gross.toStringAsFixed(1)}t',
                            bgColor: const Color(0xFFF1F5F9),
                            textColor: const Color(0xFF475569),
                          ),
                          const SizedBox(width: 6),
                          _MiniTag(
                            label: '-${offsets.toStringAsFixed(1)}t offset',
                            bgColor: const Color(0xFFF0FDF4),
                            textColor: const Color(0xFF16A34A),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Net: ',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${net.toStringAsFixed(2)} tCO₂e/yr',
                              style: GoogleFonts.inter(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Right: actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.ios_share_outlined, size: 18, color: Color(0xFF475569)),
                      tooltip: 'Export CSV',
                      onPressed: onExportCsv,
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 6),
                    FilledButton.icon(
                      onPressed: onOpenFinalTab,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.analytics_outlined, size: 15),
                      label: Text(
                        'View Summary',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _MiniTag({required this.label, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}
