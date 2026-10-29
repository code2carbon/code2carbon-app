import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/api_constants.dart';
import '../../calculator/services/calculator_engine.dart';

/// Standalone, fully interactive ESG Audit Simulator Bottom Sheet
/// Matches carbontrack/script.js ESG Audit Simulator functionality & peer benchmarks
class EsgAuditSimulatorSheet extends StatefulWidget {
  const EsgAuditSimulatorSheet({super.key});

  @override
  State<EsgAuditSimulatorSheet> createState() => _EsgAuditSimulatorSheetState();
}

class _EsgAuditSimulatorSheetState extends State<EsgAuditSimulatorSheet> {
  int _auditStep = 0;
  bool _isAuditing = false;
  String _selectedSector = 'university';

  final List<String> _steps = [
    'Connecting to GHG Protocol factors API...',
    'Parsing Scope 1 diesel, petrol, and LPG direct activity fields...',
    'Parsing Scope 2 utilities grid values with solar mitigation offsets...',
    'Assembling Scope 3 value chain ledger (paper, travel, waste, commuters)...',
    'Generating ISO 14064-1 compliance ledger document...',
  ];

  void _runAudit() async {
    setState(() {
      _isAuditing = true;
      _auditStep = 0;
    });

    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;
      setState(() {
        _auditStep = i + 1;
      });
    }

    if (!mounted) return;
    setState(() {
      _isAuditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ESG Audit Report prepared successfully.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final engine = CalculatorEngine();
    final totalNum = engine.netTons > 0 ? engine.netTons : 82.50;
    final benchmark = ApiConstants.peerBenchmarks[_selectedSector] ??
        (name: 'University Campus', value: 120.00);

    final diffPct = ((totalNum - benchmark.value).abs() / benchmark.value * 100).round();
    final isBelow = totalNum < benchmark.value;
    final indexText = isBelow ? '$diffPct% below standard' : '$diffPct% above standard';
    final indexColor = isBelow ? AppColors.success : AppColors.error;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.verified_outlined, color: AppColors.secondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ESG Audit Simulator', style: AppTypography.titleMedium),
                      Text('ISO 14064-1 & GHG Protocol Verification',
                          style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Sector benchmark selector matching website
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Benchmark Sector Comparison',
                          style: AppTypography.labelLarge.copyWith(fontSize: 13)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedSector,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: ApiConstants.peerBenchmarks.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(
                              '${entry.value.name} (${entry.value.value.toStringAsFixed(1)} tCO₂e)',
                              style: AppTypography.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedSector = val);
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Assessed Footprint', style: AppTypography.bodySmall),
                              Text('${totalNum.toStringAsFixed(2)} tCO₂e',
                                  style: AppTypography.titleMedium),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Peer Variance', style: AppTypography.bodySmall),
                              Text(
                                indexText,
                                style: AppTypography.titleMedium.copyWith(
                                  color: indexColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text('Verification Steps', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                const SizedBox(height: 12),

                // Step status items
                for (int i = 0; i < _steps.length; i++) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _auditStep > i
                              ? const Color(0xFF10B981)
                              : (_auditStep == i && _isAuditing
                                  ? AppColors.secondaryLight
                                  : AppColors.borderSubtle),
                        ),
                        child: _auditStep > i
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : (_auditStep == i && _isAuditing
                                ? const Center(
                                    child: SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.secondary),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textMuted),
                                    ),
                                  )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _steps[i],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _auditStep > i ||
                                        (_auditStep == i && _isAuditing)
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: _auditStep > i
                                    ? AppColors.dark
                                    : AppColors.textSecondary,
                              ),
                            ),
                            if (i < _steps.length - 1)
                              Container(
                                margin: const EdgeInsets.only(left: 1, top: 4, bottom: 4),
                                width: 2,
                                height: 16,
                                color: AppColors.borderDivider,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 24),

                if (_auditStep == _steps.length && !_isAuditing) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF059669), size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Audit Verification Passed (100%)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                              Text(
                                'Calculations are consistent with CEA Database v19 & IPCC Guidelines.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: const Color(0xFF047857),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                ElevatedButton.icon(
                  onPressed: _isAuditing ? null : _runAudit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: _isAuditing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    _isAuditing
                        ? 'Simulating Audit...'
                        : (_auditStep == _steps.length
                            ? 'Re-Run Verification'
                            : 'Run Full Audit Simulator'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
