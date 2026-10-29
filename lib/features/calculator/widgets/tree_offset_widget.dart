import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/emission_factors.dart';
import '../models/ledger_models.dart';
import '../services/calculator_engine.dart';
import 'ledger_shared_widgets.dart';

const _kTreeGreen = Color(0xFF15803D);

class TreeOffsetWidget extends StatefulWidget {
  const TreeOffsetWidget({super.key});

  @override
  State<TreeOffsetWidget> createState() => _TreeOffsetWidgetState();
}

class _TreeOffsetWidgetState extends State<TreeOffsetWidget> {
  final _engine = CalculatorEngine();

  void _addNewRow() {
    final newId = 't_${DateTime.now().millisecondsSinceEpoch}';
    _engine.addTree(
      TreeOffsetRow(
        id: newId,
        speciesKey: 'neem',
        treeCount: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (context, _) {
        final totalTons = _engine.totalTreeOffsetTons;

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
                    backgroundColor: _kTreeGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text('Add Grove',
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
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.park_rounded, color: _kTreeGreen, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Native Tree Carbon Sinks',
                                style: AppTypography.titleMedium.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('Botanical Sequestration (16 native species)',
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

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: _kTreeGreen.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kTreeGreen.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 7,
                          height: 7,
                          decoration:
                              const BoxDecoration(color: _kTreeGreen, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text('Total Tree Sinks',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 12.5, color: AppColors.textPrimary)),
                    ],
                  ),
                  Text('-${totalTons.toStringAsFixed(2)} tCO₂e / yr',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800, fontSize: 13, color: _kTreeGreen)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_engine.treeRows.isEmpty)
              LedgerEmptyState(
                icon: Icons.park_outlined,
                message: 'No tree groves recorded yet.',
                onAdd: _addNewRow,
                buttonLabel: 'Add Native Tree Grove',
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _engine.treeRows.length,
                separatorBuilder: (_, __) => const LedgerCardDivider(),
                itemBuilder: (context, index) {
                  final row = _engine.treeRows[index];
                  return _TreeCard(
                    row: row,
                    index: index + 1,
                    onDelete: () => _engine.removeTree(row.id),
                    onChanged: () => _engine.refresh(),
                  );
                },
              ),
              const SizedBox(height: 16),
              LedgerAddMoreButton(
                onPressed: _addNewRow,
                label: 'Add Another Tree Grove',
                color: _kTreeGreen,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _TreeCard extends StatelessWidget {
  final TreeOffsetRow row;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _TreeCard({
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
    final nativeList = EmissionFactors.nativeTrees.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Bio Sink',
                  style: GoogleFonts.inter(
                      fontSize: 10.5, fontWeight: FontWeight.w700, color: _kTreeGreen)),
            ),
            const SizedBox(width: 8),
            Text('Grove #$index',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.dark)),
            const Spacer(),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: nativeList.contains(row.speciesKey) ? row.speciesKey : 'other',
          style: _fieldStyle,
          decoration: buildLedgerInputDeco('Tree Species'),
          items: [
            ...nativeList.map((key) {
              final rate = EmissionFactors.nativeTrees[key]!;
              final title = key.split('-').map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
              return DropdownMenuItem(
                value: key,
                child: Text('$title ($rate kg/yr)', style: _fieldStyle),
              );
            }),
            const DropdownMenuItem(
              value: 'other',
              child: Text('Other / Custom Species', style: _fieldStyle),
            ),
          ],
          onChanged: (val) {
            if (val != null) {
              row.speciesKey = val;
              onChanged();
            }
          },
        ),
        const SizedBox(height: 10),

        if (row.speciesKey == 'other') ...[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: row.customSpeciesName,
                  style: _fieldStyle,
                  decoration: buildLedgerInputDeco('Custom Species Name'),
                  onChanged: (val) {
                    row.customSpeciesName = val;
                    onChanged();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: row.customAbsorptionRate.toString(),
                  keyboardType: TextInputType.number,
                  style: _fieldStyle,
                  decoration: buildLedgerInputDeco('Absorption (kg/yr)'),
                  onChanged: (val) {
                    row.customAbsorptionRate = double.tryParse(val) ?? 25.0;
                    onChanged();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        TextFormField(
          initialValue: row.treeCount.toString(),
          keyboardType: TextInputType.number,
          style: _fieldStyle,
          decoration: buildLedgerInputDeco('Number of Mature Trees'),
          onChanged: (val) {
            row.treeCount = int.tryParse(val) ?? 0;
            onChanged();
          },
        ),
        const SizedBox(height: 10),

        LedgerCalcBadge(
          formula: '${row.treeCount} trees × ${row.absorptionRate.toStringAsFixed(1)} kg/yr',
          result: '-${row.annualOffsetTons.toStringAsFixed(3)} tCO₂e/yr',
          color: _kTreeGreen,
        ),
      ],
    );
  }
}
