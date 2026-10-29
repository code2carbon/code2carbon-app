import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../models/ledger_models.dart';
import '../services/calculator_engine.dart';
import 'ledger_shared_widgets.dart';

class VehicleLedgerWidget extends StatefulWidget {
  const VehicleLedgerWidget({super.key});

  @override
  State<VehicleLedgerWidget> createState() => _VehicleLedgerWidgetState();
}

class _VehicleLedgerWidgetState extends State<VehicleLedgerWidget> {
  final _engine = CalculatorEngine();

  void _addNewRow() {
    final newId = 'v_${DateTime.now().millisecondsSinceEpoch}';
    _engine.addVehicle(
      VehicleRow(
        id: newId,
        type: 'car',
        fuel: 'petrol',
        ownership: 'staff-owned',
        count: 5,
        distanceKmPerDay: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (context, _) {
        final totalTons = _engine.totalVehicleTonsAnnual;
        final s1Tons = _engine.vehicleScope1TonsAnnual;
        final s3Tons = _engine.vehicleScope3TonsAnnual;

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
                    'Add Entry',
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
                          child: const Icon(Icons.directions_car_rounded,
                              color: Color(0xFF475569), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Vehicle Fleet & Commute',
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Scope 1 (Fleet) & Scope 3 (Commuter)',
                                style: AppTypography.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (!isNarrow) ...[
                          const SizedBox(width: 8),
                          addButton,
                        ],
                      ],
                    ),
                    if (isNarrow) ...[
                      const SizedBox(height: 8),
                      addButton,
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 14),

            LedgerSummaryPill(
              label: 'Total Vehicle Footprint',
              value: '${totalTons.toStringAsFixed(2)} tCO₂e / yr (S1: ${s1Tons.toStringAsFixed(1)}t · S3: ${s3Tons.toStringAsFixed(1)}t)',
              color: const Color(0xFF0F172A),
            ),
            const SizedBox(height: 16),

            if (_engine.vehicles.isEmpty)
              LedgerEmptyState(
                icon: Icons.directions_car_outlined,
                message: 'No vehicles logged.',
                onAdd: _addNewRow,
                buttonLabel: 'Add Vehicle Entry',
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _engine.vehicles.length,
                separatorBuilder: (_, __) => const LedgerCardDivider(),
                itemBuilder: (context, index) {
                  final row = _engine.vehicles[index];
                  return _VehicleCard(
                    row: row,
                    index: index + 1,
                    onDelete: () => _engine.removeVehicle(row.id),
                    onChanged: () => _engine.refresh(),
                  );
                },
              ),
              const SizedBox(height: 16),
              LedgerAddMoreButton(
                onPressed: _addNewRow,
                label: 'Add Another Vehicle Entry',
                color: const Color(0xFF0F172A),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleRow row;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _VehicleCard({
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
              child: Text(
                'Vehicle #$index · ${row.scope}',
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

        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: row.type,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Vehicle Type'),
                items: const [
                  DropdownMenuItem(value: 'car', child: Text('Car', style: _fieldStyle)),
                  DropdownMenuItem(value: 'bus', child: Text('Bus', style: _fieldStyle)),
                  DropdownMenuItem(value: 'van', child: Text('Van', style: _fieldStyle)),
                  DropdownMenuItem(value: 'bike', child: Text('Motorcycle/Bike', style: _fieldStyle)),
                  DropdownMenuItem(value: 'truck', child: Text('Truck', style: _fieldStyle)),
                  DropdownMenuItem(value: 'auto-rickshaw', child: Text('Auto Rickshaw', style: _fieldStyle)),
                ],
                onChanged: (val) {
                  if (val != null) {
                    row.type = val;
                    onChanged();
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: row.fuel,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Fuel Type'),
                items: const [
                  DropdownMenuItem(value: 'petrol', child: Text('Petrol', style: _fieldStyle)),
                  DropdownMenuItem(value: 'diesel', child: Text('Diesel', style: _fieldStyle)),
                  DropdownMenuItem(value: 'cng', child: Text('CNG', style: _fieldStyle)),
                  DropdownMenuItem(value: 'electric', child: Text('Electric (EV)', style: _fieldStyle)),
                ],
                onChanged: (val) {
                  if (val != null) {
                    row.fuel = val;
                    onChanged();
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        DropdownButtonFormField<String>(
          value: row.ownership,
          style: _fieldStyle,
          decoration: buildLedgerInputDeco('Ownership Allocation'),
          items: const [
            DropdownMenuItem(
              value: 'institute-owned',
              child: Text('Institute Owned (Scope 1/2)', style: _fieldStyle),
            ),
            DropdownMenuItem(
              value: 'staff-owned',
              child: Text('Staff Owned (Scope 3)', style: _fieldStyle),
            ),
            DropdownMenuItem(
              value: 'student-owned',
              child: Text('Student Owned (Scope 3)', style: _fieldStyle),
            ),
            DropdownMenuItem(
              value: 'other',
              child: Text('Other Commuter (Scope 3)', style: _fieldStyle),
            ),
          ],
          onChanged: (val) {
            if (val != null) {
              row.ownership = val;
              onChanged();
            }
          },
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: row.count.toInt().toString(),
                keyboardType: TextInputType.number,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Count (Vehicles)'),
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0;
                  row.count = parsed < 0 ? 0 : parsed;
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: row.distanceKmPerDay.toString(),
                keyboardType: TextInputType.number,
                style: _fieldStyle,
                decoration: buildLedgerInputDeco('Avg Dist (km/day)'),
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0;
                  row.distanceKmPerDay = parsed < 0 ? 0 : parsed;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        LedgerCalcBadge(
          formula:
              '${row.count.toInt()} × ${row.distanceKmPerDay.toStringAsFixed(0)} km/day × ${row.factor} factor',
          result: '${row.annualTons.toStringAsFixed(3)} tCO₂e/yr',
          color: const Color(0xFF0F172A),
        ),
      ],
    );
  }
}
