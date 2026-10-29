/// Aggregated Carbon Inventory Calculation Summary
class CalculationSummary {
  final double vehicleKg;
  final double energyKg;
  final double generatorKg;
  final double lpgKg;
  final double paperKg;

  final double solarOffsetKg;
  final double treeSinkKg;
  final double wasteOffsetKg;

  const CalculationSummary({
    this.vehicleKg = 0.0,
    this.energyKg = 0.0,
    this.generatorKg = 0.0,
    this.lpgKg = 0.0,
    this.paperKg = 0.0,
    this.solarOffsetKg = 0.0,
    this.treeSinkKg = 0.0,
    this.wasteOffsetKg = 0.0,
  });

  // Gross Operational Emissions
  double get grossKg =>
      vehicleKg + energyKg + generatorKg + lpgKg + paperKg;
  double get grossTons => grossKg / 1000.0;

  // Total Clean Offsets
  double get offsetsKg => solarOffsetKg + treeSinkKg + wasteOffsetKg;
  double get offsetsTons => offsetsKg / 1000.0;

  // Net Operational Footprint (Gross - Offsets)
  double get netKg => grossKg - offsetsKg;
  double get netTons => netKg / 1000.0;

  // Percentage Shares
  double get scope1Kg => generatorKg + lpgKg; // Vehicles get split by ownership
  double get scope2Kg => energyKg;
  double get scope3Kg => paperKg;

  CalculationSummary copyWith({
    double? vehicleKg,
    double? energyKg,
    double? generatorKg,
    double? lpgKg,
    double? paperKg,
    double? solarOffsetKg,
    double? treeSinkKg,
    double? wasteOffsetKg,
  }) {
    return CalculationSummary(
      vehicleKg: vehicleKg ?? this.vehicleKg,
      energyKg: energyKg ?? this.energyKg,
      generatorKg: generatorKg ?? this.generatorKg,
      lpgKg: lpgKg ?? this.lpgKg,
      paperKg: paperKg ?? this.paperKg,
      solarOffsetKg: solarOffsetKg ?? this.solarOffsetKg,
      treeSinkKg: treeSinkKg ?? this.treeSinkKg,
      wasteOffsetKg: wasteOffsetKg ?? this.wasteOffsetKg,
    );
  }
}
