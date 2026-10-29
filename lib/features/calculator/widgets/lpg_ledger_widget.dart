import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/ledger_models.dart';
import '../services/calculator_engine.dart';
import 'ledger_shared_widgets.dart';

class LpgLedgerWidget extends StatefulWidget {
  const LpgLedgerWidget({super.key});

  @override
  State<LpgLedgerWidget> createState() => _LpgLedgerWidgetState();
}

class _LpgLedgerWidgetState extends State<LpgLedgerWidget> {
  final _engine = CalculatorEngine();

  void _addNewRow() {
    final newId = 'lpg_${DateTime.now().millisecondsSinceEpoch}';
    _engine.addLpg(
      LpgRow(
        id: newId,
        locationKey: 'canteen',
        customLocation: 'Main Cafeteria',
        cylinders: 15.0,
        weight: 19.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (context, _) {
        final totalTons = _engine.totalLpgTonsAnnual;

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
                  label: Text('Add LPG',
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
                          child: const Icon(Icons.outdoor_grill_rounded,
                              color: Color(0xFF475569), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'LPG Dining & Mess',
                                style: AppTypography.titleMedium.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('Scope 1 · Factor: 2.988 kg/kg',
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
              label: 'LPG Kitchens Scope 1 Total',
              value: '${totalTons.toStringAsFixed(2)} tCO₂e / yr',
              color: const Color(0xFFD97706),
            ),
            const SizedBox(height: 16),

            if (_engine.lpgRows.isEmpty)
              LedgerEmptyState(
                icon: Icons.outdoor_grill_outlined,
                message: 'No LPG kitchen rows logged.',
                onAdd: _addNewRow,
                buttonLabel: 'Add LPG Entry',
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _engine.lpgRows.length,
                separatorBuilder: (_, __) => const LedgerCardDivider(),
                itemBuilder: (context, index) {
                  final row = _engine.lpgRows[index];
                  return _LpgCard(
                    row: row,
                    index: index + 1,
                    onDelete: () => _engine.removeLpg(row.id),
                    onChanged: () => _engine.refresh(),
                  );
                },
              ),
              const SizedBox(height: 16),
              LedgerAddMoreButton(
                onPressed: _addNewRow,
                label: 'Add Another LPG Facility',
                color: const Color(0xFF0F172A),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _LpgCard extends StatefulWidget {
  final LpgRow row;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _LpgCard({
    required this.row,
    required this.index,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  State<_LpgCard> createState() => _LpgCardState();
}

class _LpgCardState extends State<_LpgCard> {
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
              child: Text(
                'LPG Station #${widget.index}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: widget.onDelete,
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
          value: widget.row.locationKey,
          style: _fieldStyle,
          decoration: buildLedgerInputDeco('Kitchen Location Preset'),
          items: const [
            DropdownMenuItem(value: 'boys-hostel-mess', child: Text('Boys Hostel Mess', style: _fieldStyle)),
            DropdownMenuItem(value: 'girls-hostel-mess', child: Text('Girls Hostel Mess', style: _fieldStyle)),
            DropdownMenuItem(value: 'canteen', child: Text('Campus Central Cafeteria', style: _fieldStyle)),
            DropdownMenuItem(value: 'faculty-dining', child: Text('Faculty Club Dining', style: _fieldStyle)),
            DropdownMenuItem(value: 'other', child: Text('Custom Mess / Dining Location', style: _fieldStyle)),
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                widget.row.locationKey = val;
              });
              widget.onChanged();
            }
          },
        ),
        const SizedBox(height: 10),

        if (widget.row.locationKey == 'other') ...[
          TextFormField(
            initialValue: widget.row.customLocation,
            style: _fieldStyle,
            decoration: buildLedgerInputDeco('Custom Dining Facility Name'),
            onChanged: (val) {
              widget.row.customLocation = val;
              widget.onChanged();
            },
          ),
          const SizedBox(height: 10),
        ],

        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: widget.row.cylinders.toString(),
                keyboardType: TextInputType.number,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Cylinders / Month'),
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0;
                  widget.row.cylinders = parsed < 0 ? 0 : parsed;
                  widget.onChanged();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: widget.row.weight.toString(),
                keyboardType: TextInputType.number,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Weight / Cyl (kg)'),
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0;
                  widget.row.weight = parsed < 0 ? 0 : parsed;
                  widget.onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        LedgerCalcBadge(
          formula:
              '${widget.row.cylinders.toStringAsFixed(0)} cyl × ${widget.row.weight.toStringAsFixed(1)} kg × 2.988',
          result: '${widget.row.annualTons.toStringAsFixed(3)} tCO₂e/yr',
          color: const Color(0xFFD97706),
        ),
      ],
    );
  }
}
