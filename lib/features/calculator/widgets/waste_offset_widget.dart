import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/emission_factors.dart';
import '../models/ledger_models.dart';
import '../services/calculator_engine.dart';
import 'ledger_shared_widgets.dart';

class WasteOffsetWidget extends StatefulWidget {
  const WasteOffsetWidget({super.key});

  @override
  State<WasteOffsetWidget> createState() => _WasteOffsetWidgetState();
}

class _WasteOffsetWidgetState extends State<WasteOffsetWidget> {
  final _engine = CalculatorEngine();

  void _addNewRow() {
    final newId = 'w_${DateTime.now().millisecondsSinceEpoch}';
    _engine.addWaste(
      WasteOffsetRow(
        id: newId,
        materialKey: 'organic',
        monthlyRecycledKg: 400.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (context, _) {
        final totalTons = _engine.totalWasteOffsetTons;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header — Clean & Eye-friendly
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
                  label: Text('Add Stream',
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
                          child: const Icon(Icons.recycling_rounded, color: Color(0xFF475569), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Waste Recycling & Offsets',
                                style: AppTypography.titleMedium.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('Avoided Landfill Emissions (10 materials)',
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

            // Summary Pill — Calm & Neutral
            LedgerSummaryPill(
              label: 'Total Waste Recycling Offsets',
              value: '-${totalTons.toStringAsFixed(2)} tCO₂e / yr',
              color: const Color(0xFF059669),
            ),
            const SizedBox(height: 16),

            if (_engine.wasteRows.isEmpty)
              LedgerEmptyState(
                icon: Icons.recycling_outlined,
                message: 'No waste recycling logged.',
                onAdd: _addNewRow,
                buttonLabel: 'Add Recycled Material',
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _engine.wasteRows.length,
                separatorBuilder: (_, __) => const LedgerCardDivider(),
                itemBuilder: (context, index) {
                  final row = _engine.wasteRows[index];
                  return _WasteCard(
                    row: row,
                    index: index + 1,
                    onDelete: () => _engine.removeWaste(row.id),
                    onChanged: () => _engine.refresh(),
                  );
                },
              ),
              const SizedBox(height: 16),
              LedgerAddMoreButton(
                onPressed: _addNewRow,
                label: 'Add Another Waste Stream',
                color: const Color(0xFF0F172A),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _WasteCard extends StatelessWidget {
  final WasteOffsetRow row;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _WasteCard({
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
    final materials = EmissionFactors.wasteCoefficients.keys.toList();

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
              child: Text(
                'Stream #$index',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF475569),
                ),
              ),
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

        DropdownButtonFormField<String>(
          value: materials.contains(row.materialKey) ? row.materialKey : materials.first,
          style: _fieldStyle,
          decoration: buildLedgerInputDeco('Material Category'),
          items: materials.map((key) {
            final factor = EmissionFactors.wasteCoefficients[key]!;
            final title = '${key[0].toUpperCase()}${key.substring(1)}';
            return DropdownMenuItem(
              value: key,
              child: Text('$title ($factor kg avoided/kg)', style: _fieldStyle),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              row.materialKey = val;
              onChanged();
            }
          },
        ),
        const SizedBox(height: 10),

        TextFormField(
          initialValue: row.monthlyRecycledKg.toString(),
          keyboardType: TextInputType.number,
          style: _fieldStyle,
          decoration: buildLedgerInputDeco('Monthly Recycled / Composted (kg)'),
          onChanged: (val) {
            row.monthlyRecycledKg = double.tryParse(val) ?? 0;
            onChanged();
          },
        ),
        const SizedBox(height: 10),

        LedgerCalcBadge(
          formula: 'Factor: ${row.factor.toStringAsFixed(2)} kg/kg',
          result: 'Avoided: -${row.annualOffsetTons.toStringAsFixed(3)} t',
          color: const Color(0xFF059669),
        ),
      ],
    );
  }
}
