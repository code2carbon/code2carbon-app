import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/ledger_models.dart';
import '../services/calculator_engine.dart';
import 'ledger_shared_widgets.dart';

class PaperLedgerWidget extends StatefulWidget {
  const PaperLedgerWidget({super.key});

  @override
  State<PaperLedgerWidget> createState() => _PaperLedgerWidgetState();
}

class _PaperLedgerWidgetState extends State<PaperLedgerWidget> {
  final _engine = CalculatorEngine();

  void _addNewDept() {
    final newId = 'p_${DateTime.now().millisecondsSinceEpoch}';
    _engine.addPaperDept(
      PaperDeptRow(
        id: newId,
        department: 'Academic Dept #${_engine.paperDeptRows.length + 1}',
        annualReams: 150.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (context, _) {
        final deptTons = _engine.deptPaperTonsAnnual;
        final totalPaperTons = _engine.totalPaperTonsAnnual;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                final addButton = FilledButton.icon(
                  onPressed: _addNewDept,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text('Add Dept',
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
                          child: const Icon(Icons.menu_book_rounded, color: Color(0xFF475569), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Paper & Headcount Ledger',
                                style: AppTypography.titleMedium.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('Scope 3 · Factor: 3.591 kg/kg', style: AppTypography.bodySmall),
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
              label: 'Paper Scope 3 Total',
              value: '${totalPaperTons.toStringAsFixed(2)} tCO₂e / yr',
              color: const Color(0xFF4F46E5),
            ),
            const SizedBox(height: 14),

            // Student Headcount Sync — flat info card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sync_rounded, size: 15, color: Color(0xFF475569)),
                      const SizedBox(width: 6),
                      Text(
                        'Student Headcount Sync',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.dark),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_engine.profile.studentsCount} Students',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Standard benchmark: 0.75 kg paper / student / academic year.',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Annual Paper Consumption:',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11.5)),
                      Text('${_engine.studentPaperKgAnnual.toStringAsFixed(0)} kg',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Emissions (Scope 3):', style: AppTypography.bodySmall.copyWith(fontSize: 11.5)),
                      Text(
                        '${_engine.studentPaperTonsAnnual.toStringAsFixed(3)} tCO₂e / yr',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12, color: const Color(0xFF4F46E5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Department Paper Logs',
                  style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Subtotal: ${deptTons.toStringAsFixed(2)} t',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 12, color: const Color(0xFF475569)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_engine.paperDeptRows.isEmpty)
              LedgerEmptyState(
                icon: Icons.menu_book_outlined,
                message: 'No departmental paper logs.',
                onAdd: _addNewDept,
                buttonLabel: 'Add Department',
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _engine.paperDeptRows.length,
                separatorBuilder: (_, __) => const LedgerCardDivider(),
                itemBuilder: (context, index) {
                  final row = _engine.paperDeptRows[index];
                  return _PaperDeptCard(
                    row: row,
                    index: index + 1,
                    onDelete: () => _engine.removePaperDept(row.id),
                    onChanged: () => _engine.refresh(),
                  );
                },
              ),
              const SizedBox(height: 16),
              LedgerAddMoreButton(onPressed: _addNewDept, label: 'Add Another Department', color: const Color(0xFF0F172A)),
            ],
          ],
        );
      },
    );
  }
}

class _PaperDeptCard extends StatelessWidget {
  final PaperDeptRow row;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _PaperDeptCard({
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
              child: Text('Dept #$index',
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

        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: row.department,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Department Name'),
                onChanged: (val) {
                  row.department = val;
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: row.annualReams.toString(),
                keyboardType: TextInputType.number,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Reams (2.5 kg/ream)'),
                onChanged: (val) {
                  row.annualReams = double.tryParse(val) ?? 0;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        LedgerCalcBadge(
          formula: '${row.totalKg.toStringAsFixed(1)} kg × 3.591 factor',
          result: '${row.annualTons.toStringAsFixed(3)} tCO₂e/yr',
          color: const Color(0xFF4F46E5),
        ),
      ],
    );
  }
}
