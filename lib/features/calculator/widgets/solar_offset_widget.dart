import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/ledger_models.dart';
import '../services/calculator_engine.dart';
import 'ledger_shared_widgets.dart';

class SolarOffsetWidget extends StatefulWidget {
  const SolarOffsetWidget({super.key});

  @override
  State<SolarOffsetWidget> createState() => _SolarOffsetWidgetState();
}

class _SolarOffsetWidgetState extends State<SolarOffsetWidget> {
  final _engine = CalculatorEngine();

  void _addNewRow() {
    final newId = 's_${DateTime.now().millisecondsSinceEpoch}';
    _engine.addSolar(
      SolarOffsetRow(
        id: newId,
        name: 'Rooftop Solar Array #${_engine.solarRows.length + 1}',
        capacityKw: 50.0,
        monthlyGenerationKwh: 6500.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (context, _) {
        final totalTons = _engine.totalSolarOffsetTons;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                final addButton = FilledButton.icon(
                  onPressed: _addNewRow,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text('Add Array',
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600)),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.solar_power_rounded,
                              color: Color(0xFF475569), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Solar PV Clean Offsets',
                                style: AppTypography.titleMedium.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('Avoided Grid Carbon · 0.792 kg/kWh',
                                  style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                        if (!isNarrow) ...[const SizedBox(width: 8), addButton],
                      ],
                    ),
                    if (isNarrow) ...[const SizedBox(height: 8), addButton],
                  ],
                );
              },
            ),
            const SizedBox(height: 14),

            LedgerSummaryPill(
              label: 'Total Solar Offsets',
              value: '-${totalTons.toStringAsFixed(2)} tCO₂e / yr',
              color: const Color(0xFF059669),
            ),
            const SizedBox(height: 16),

            if (_engine.solarRows.isEmpty)
              LedgerEmptyState(
                icon: Icons.solar_power_outlined,
                message: 'No solar PV arrays logged.',
                onAdd: _addNewRow,
                buttonLabel: 'Add Solar Array',
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _engine.solarRows.length,
                separatorBuilder: (_, __) => const LedgerCardDivider(),
                itemBuilder: (context, index) {
                  final row = _engine.solarRows[index];
                  return _SolarCard(
                    row: row,
                    index: index + 1,
                    onDelete: () => _engine.removeSolar(row.id),
                    onChanged: () => _engine.refresh(),
                  );
                },
              ),
              const SizedBox(height: 16),
              LedgerAddMoreButton(onPressed: _addNewRow, label: 'Add Another Solar Array', color: const Color(0xFF0F172A)),
            ],
          ],
        );
      },
    );
  }
}

class _SolarCard extends StatelessWidget {
  final SolarOffsetRow row;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _SolarCard({
    required this.row,
    required this.index,
    required this.onDelete,
    required this.onChanged,
  });

  static const _fieldStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Array #$index',
                  style: GoogleFonts.inter(
                      fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF475569))),
            ),
            const Spacer(),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFF94A3B8)),
              tooltip: 'Remove',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
              hoverColor: const Color(0xFFFEE2E2),
              highlightColor: const Color(0xFFFEE2E2),
            ),
          ],
        ),
        const SizedBox(height: 10),

        TextFormField(
          initialValue: row.name,
          style: _fieldStyle,
          decoration: buildLedgerInputDeco('Solar Installation Name'),
          onChanged: (val) {
            row.name = val;
            onChanged();
          },
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: row.capacityKw.toString(),
                keyboardType: TextInputType.number,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Capacity (kW)'),
                onChanged: (val) {
                  row.capacityKw = double.tryParse(val) ?? 0;
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: row.monthlyGenerationKwh.toString(),
                keyboardType: TextInputType.number,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Monthly Gen (kWh)'),
                onChanged: (val) {
                  row.monthlyGenerationKwh = double.tryParse(val) ?? 0;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        LedgerCalcBadge(
          formula:
              '${row.monthlyGenerationKwh.toStringAsFixed(0)} kWh × ${row.factor} × 12 mo',
          result: '-${row.annualOffsetTons.toStringAsFixed(3)} tCO₂e/yr',
          color: const Color(0xFF059669),
        ),
      ],
    );
  }
}
