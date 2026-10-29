import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/ledger_models.dart';
import '../services/calculator_engine.dart';
import 'ledger_shared_widgets.dart';

class GeneratorLedgerWidget extends StatefulWidget {
  const GeneratorLedgerWidget({super.key});

  @override
  State<GeneratorLedgerWidget> createState() => _GeneratorLedgerWidgetState();
}

class _GeneratorLedgerWidgetState extends State<GeneratorLedgerWidget> {
  final _engine = CalculatorEngine();

  void _addNewRow() {
    final newId = 'g_${DateTime.now().millisecondsSinceEpoch}';
    _engine.addGenerator(
      GeneratorRow(
        id: newId,
        location: 'Backup Generator #${_engine.generators.length + 1}',
        monthlyDieselLitres: 400.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (context, _) {
        final totalTons = _engine.totalGeneratorTonsAnnual;

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
                  label: Text(
                    'Add GenSet',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
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
                          child: const Icon(Icons.electrical_services_rounded,
                              color: Color(0xFF475569), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Diesel Generators',
                                style: AppTypography.titleMedium.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('Scope 1 · Factor: 2.684 kg/L',
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
              label: 'Generator Scope 1 Total',
              value: '${totalTons.toStringAsFixed(2)} tCO₂e / yr',
              color: const Color(0xFFD97706),
            ),
            const SizedBox(height: 16),

            if (_engine.generators.isEmpty)
              LedgerEmptyState(
                icon: Icons.electrical_services_outlined,
                message: 'No generators logged.',
                onAdd: _addNewRow,
                buttonLabel: 'Add GenSet',
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _engine.generators.length,
                separatorBuilder: (_, __) => const LedgerCardDivider(),
                itemBuilder: (context, index) {
                  final row = _engine.generators[index];
                  return _GeneratorCard(
                    row: row,
                    index: index + 1,
                    onDelete: () => _engine.removeGenerator(row.id),
                    onChanged: () => _engine.refresh(),
                  );
                },
              ),
              const SizedBox(height: 16),
              LedgerAddMoreButton(
                onPressed: _addNewRow,
                label: 'Add Another Generator',
                color: const Color(0xFF0F172A),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _GeneratorCard extends StatefulWidget {
  final GeneratorRow row;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _GeneratorCard({
    required this.row,
    required this.index,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  State<_GeneratorCard> createState() => _GeneratorCardState();
}

class _GeneratorCardState extends State<_GeneratorCard> {
  Future<void> _pickBill() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result.isNotEmpty) {
      setState(() {
        widget.row.billAttachmentPath = result.first.path;
        widget.row.billFileName = result.first.name;
      });
      widget.onChanged();
    }
  }

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
                'Generator #${widget.index}',
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

        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: widget.row.location,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Location / Name'),
                onChanged: (val) {
                  widget.row.location = val;
                  widget.onChanged();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: widget.row.monthlyDieselLitres.toString(),
                keyboardType: TextInputType.number,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Diesel (L/mo)'),
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0;
                  widget.row.monthlyDieselLitres = parsed < 0 ? 0 : parsed;
                  widget.onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        InkWell(
          onTap: _pickBill,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.row.billFileName != null
                  ? const Color(0xFFF0FDF4)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.row.billFileName != null
                    ? const Color(0xFF86EFAC)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.row.billFileName != null
                      ? Icons.check_circle_outline_rounded
                      : Icons.receipt_long_outlined,
                  size: 16,
                  color: widget.row.billFileName != null
                      ? const Color(0xFF15803D)
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.row.billFileName ?? 'Attach Diesel Slip / Bill (PDF/IMG)',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: widget.row.billFileName != null
                          ? const Color(0xFF15803D)
                          : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.row.billFileName != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.row.billFileName = null;
                        widget.row.billAttachmentPath = null;
                      });
                      widget.onChanged();
                    },
                    child: const Icon(Icons.close_rounded, size: 15, color: Color(0xFFEF4444)),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        LedgerCalcBadge(
          formula: '${widget.row.monthlyDieselLitres.toStringAsFixed(0)} L × 2.684 × 12 mo',
          result: '${widget.row.annualTons.toStringAsFixed(3)} tCO₂e/yr',
          color: const Color(0xFFD97706),
        ),
      ],
    );
  }
}
