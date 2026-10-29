import 'package:flutter/foundation.dart';
import '../../../core/constants/emission_factors.dart';
import '../models/institution_profile.dart';
import '../models/ledger_models.dart';

class CalculatorEngine extends ChangeNotifier {
  static final CalculatorEngine _instance = CalculatorEngine._internal();
  factory CalculatorEngine() => _instance;
  CalculatorEngine._internal() {
    _loadDefaults();
  }

  late InstitutionProfile profile;
  late List<VehicleRow> vehicles;
  late List<EnergyRow> energyRows;
  late List<GeneratorRow> generators;
  late List<LpgRow> lpgRows;
  late List<PaperDeptRow> paperDeptRows;
  late List<SolarOffsetRow> solarRows;
  late List<TreeOffsetRow> treeRows;
  late List<WasteOffsetRow> wasteRows;

  void _loadDefaults() {
    profile = InstitutionProfile();

    vehicles = [
      VehicleRow(
        id: 'v1',
        type: 'bus',
        fuel: 'diesel',
        ownership: 'institute-owned',
        count: 8,
        distanceKmPerDay: 45.0,
      ),
      VehicleRow(
        id: 'v2',
        type: 'car',
        fuel: 'petrol',
        ownership: 'staff-owned',
        count: 42,
        distanceKmPerDay: 18.0,
      ),
      VehicleRow(
        id: 'v3',
        type: 'bike',
        fuel: 'petrol',
        ownership: 'student-owned',
        count: 110,
        distanceKmPerDay: 12.0,
      ),
      VehicleRow(
        id: 'v4',
        type: 'van',
        fuel: 'cng',
        ownership: 'institute-owned',
        count: 3,
        distanceKmPerDay: 30.0,
      ),
    ];

    energyRows = [
      EnergyRow(
        id: 'e1',
        type: 'purchased-grid',
        source: 'State Electricity Board',
        monthlyKwh: 38500.0,
      ),
      EnergyRow(
        id: 'e2',
        type: 'natural-gas',
        source: 'Research Labs Co-Gen',
        monthlyKwh: 4200.0,
      ),
    ];

    generators = [
      GeneratorRow(
        id: 'g1',
        location: 'Central Campus Substation',
        monthlyDieselLitres: 520.0,
      ),
      GeneratorRow(
        id: 'g2',
        location: 'Data Center & Library Backup',
        monthlyDieselLitres: 280.0,
      ),
    ];

    lpgRows = [
      LpgRow(
        id: 'l1',
        locationKey: 'boys-hostel-mess',
        cylinders: 60.0,
        weight: 14.2,
      ),
      LpgRow(
        id: 'l2',
        locationKey: 'canteen',
        cylinders: 22.0,
        weight: 14.2,
      ),
    ];

    paperDeptRows = [
      PaperDeptRow(
        id: 'p1',
        department: 'Examination & Registrar Office',
        annualReams: 350.0,
      ),
      PaperDeptRow(
        id: 'p2',
        department: 'Academic Departments & Library',
        annualReams: 220.0,
      ),
    ];

    solarRows = [
      SolarOffsetRow(
        id: 's1',
        name: 'Engineering Block Rooftop PV (100 kW)',
        capacityKw: 100.0,
        monthlyGenerationKwh: 11500.0,
      ),
      SolarOffsetRow(
        id: 's2',
        name: 'Hostel Solar Water & Power (35 kW)',
        capacityKw: 35.0,
        monthlyGenerationKwh: 3800.0,
      ),
    ];

    treeRows = [
      TreeOffsetRow(
        id: 't1',
        speciesKey: 'neem',
        treeCount: 160,
      ),
      TreeOffsetRow(
        id: 't2',
        speciesKey: 'banyan',
        treeCount: 28,
      ),
      TreeOffsetRow(
        id: 't3',
        speciesKey: 'peepal',
        treeCount: 45,
      ),
      TreeOffsetRow(
        id: 't4',
        speciesKey: 'cluster-fig',
        treeCount: 50,
      ),
    ];

    wasteRows = [
      WasteOffsetRow(
        id: 'w1',
        materialKey: 'paper',
        monthlyRecycledKg: 420.0,
      ),
      WasteOffsetRow(
        id: 'w2',
        materialKey: 'plastic',
        monthlyRecycledKg: 180.0,
      ),
      WasteOffsetRow(
        id: 'w3',
        materialKey: 'organic',
        monthlyRecycledKg: 950.0,
      ),
    ];
  }

  // Two-way Student Headcount Paper Baseline calculation:
  // Students × 12 months × 125 sheets × 0.0005 kg = Students × 0.75 kg/yr
  double get studentPaperKgAnnual =>
      profile.studentsCount * EmissionFactors.studentPaperFactor;
  double get studentPaperTonsAnnual =>
      (studentPaperKgAnnual * EmissionFactors.paperFactor) / 1000.0;

  double get deptPaperKgAnnual =>
      paperDeptRows.fold(0.0, (sum, r) => sum + r.annualKg);
  double get deptPaperTonsAnnual =>
      paperDeptRows.fold(0.0, (sum, r) => sum + r.annualTons);

  double get totalPaperTonsAnnual =>
      studentPaperTonsAnnual + deptPaperTonsAnnual;

  // Category Aggregate Emissions
  double get totalVehicleTonsAnnual =>
      vehicles.fold(0.0, (sum, v) => sum + v.annualTons);

  double get vehicleScope1TonsAnnual => vehicles
      .where((v) => v.scope == 'Scope 1')
      .fold(0.0, (sum, v) => sum + v.annualTons);

  double get vehicleScope2TonsAnnual => vehicles
      .where((v) => v.scope == 'Scope 2')
      .fold(0.0, (sum, v) => sum + v.annualTons);

  double get vehicleScope3TonsAnnual => vehicles
      .where((v) => v.scope == 'Scope 3')
      .fold(0.0, (sum, v) => sum + v.annualTons);

  double get totalEnergyTonsAnnual =>
      energyRows.fold(0.0, (sum, e) => sum + e.annualTons);

  double get totalGeneratorTonsAnnual =>
      generators.fold(0.0, (sum, g) => sum + g.annualTons);

  double get totalLpgTonsAnnual =>
      lpgRows.fold(0.0, (sum, l) => sum + l.annualTons);

  // Scope 1, 2, 3 Totals
  double get totalScope1Tons =>
      vehicleScope1TonsAnnual +
      totalGeneratorTonsAnnual +
      totalLpgTonsAnnual;

  double get totalScope2Tons =>
      totalEnergyTonsAnnual + vehicleScope2TonsAnnual;

  double get totalScope3Tons =>
      vehicleScope3TonsAnnual + totalPaperTonsAnnual;

  // Clean Offsets
  double get totalSolarOffsetTons =>
      solarRows.fold(0.0, (sum, s) => sum + s.annualOffsetTons);

  double get totalTreeOffsetTons =>
      treeRows.fold(0.0, (sum, t) => sum + t.annualOffsetTons);

  double get totalWasteOffsetTons =>
      wasteRows.fold(0.0, (sum, w) => sum + w.annualOffsetTons);

  double get totalCleanOffsetsTons =>
      totalSolarOffsetTons + totalTreeOffsetTons + totalWasteOffsetTons;

  // Gross & Net Footprint
  double get grossTons => totalScope1Tons + totalScope2Tons + totalScope3Tons;
  double get netTons => (grossTons - totalCleanOffsetsTons).clamp(0.0, double.infinity);

  // Intensity Metrics
  double get perCapitaTons =>
      profile.totalPopulation > 0 ? (netTons / profile.totalPopulation) : 0.0;

  double get perSqmKg =>
      profile.builtUpAreaSqm > 0 ? ((netTons * 1000.0) / profile.builtUpAreaSqm) : 0.0;

  // Mutation and Notification methods
  void updateProfile(InstitutionProfile newProfile) {
    profile = newProfile;
    notifyListeners();
  }

  void addVehicle(VehicleRow row) {
    vehicles.add(row);
    notifyListeners();
  }

  void removeVehicle(String id) {
    vehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  void addEnergy(EnergyRow row) {
    energyRows.add(row);
    notifyListeners();
  }

  void removeEnergy(String id) {
    energyRows.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void addGenerator(GeneratorRow row) {
    generators.add(row);
    notifyListeners();
  }

  void removeGenerator(String id) {
    generators.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  void addLpg(LpgRow row) {
    lpgRows.add(row);
    notifyListeners();
  }

  void removeLpg(String id) {
    lpgRows.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  void addPaperDept(PaperDeptRow row) {
    paperDeptRows.add(row);
    notifyListeners();
  }

  void removePaperDept(String id) {
    paperDeptRows.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void addSolar(SolarOffsetRow row) {
    solarRows.add(row);
    notifyListeners();
  }

  void removeSolar(String id) {
    solarRows.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void addTree(TreeOffsetRow row) {
    treeRows.add(row);
    notifyListeners();
  }

  void removeTree(String id) {
    treeRows.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void addWaste(WasteOffsetRow row) {
    wasteRows.add(row);
    notifyListeners();
  }

  void removeWaste(String id) {
    wasteRows.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  /// Generates a CSV data string for full ledger audit backup
  String generateCsvReport() {
    final buffer = StringBuffer();
    buffer.writeln('CarbonTrack Institutional Assessment Ledger');
    buffer.writeln('Institution,${profile.name}');
    buffer.writeln('Address,${profile.address}');
    buffer.writeln('Total Population,${profile.totalPopulation}');
    buffer.writeln('Built-up Area (sqm),${profile.builtUpAreaSqm}');
    buffer.writeln('Gross Emissions (tCO2e),${grossTons.toStringAsFixed(2)}');
    buffer.writeln('Total Offsets (tCO2e),${totalCleanOffsetsTons.toStringAsFixed(2)}');
    buffer.writeln('Net Carbon Footprint (tCO2e),${netTons.toStringAsFixed(2)}');
    buffer.writeln('Scope 1 (tCO2e),${totalScope1Tons.toStringAsFixed(2)}');
    buffer.writeln('Scope 2 (tCO2e),${totalScope2Tons.toStringAsFixed(2)}');
    buffer.writeln('Scope 3 (tCO2e),${totalScope3Tons.toStringAsFixed(2)}');
    buffer.writeln('Per Capita Intensity (tCO2e/person),${perCapitaTons.toStringAsFixed(3)}');
    buffer.writeln('Spatial Intensity (kgCO2e/m2),${perSqmKg.toStringAsFixed(2)}');
    buffer.writeln('');
    buffer.writeln('1. VEHICLES LEDGER');
    buffer.writeln('Type,Fuel,Ownership,Scope,Count,Distance (km/day),Annual (tCO2e)');
    for (var v in vehicles) {
      buffer.writeln('${v.type},${v.fuel},${v.ownership},${v.scope},${v.count},${v.distanceKmPerDay},${v.annualTons.toStringAsFixed(3)}');
    }
    buffer.writeln('');
    buffer.writeln('2. ENERGY & ELECTRICITY LEDGER');
    buffer.writeln('Type,Source,Monthly kWh,Factor,Annual (tCO2e)');
    for (var e in energyRows) {
      buffer.writeln('${e.type},${e.source},${e.monthlyKwh},${e.factor},${e.annualTons.toStringAsFixed(3)}');
    }
    buffer.writeln('');
    buffer.writeln('3. DIESEL GENERATORS LEDGER');
    buffer.writeln('Location,Monthly Liters,Factor (kg/L),Annual (tCO2e)');
    for (var g in generators) {
      buffer.writeln('${g.location},${g.monthlyDieselLitres},${g.factor},${g.annualTons.toStringAsFixed(3)}');
    }
    buffer.writeln('');
    buffer.writeln('4. LPG DINING & MESS LEDGER');
    buffer.writeln('Location,Cylinders/mo,Weight (kg),Annual (tCO2e)');
    for (var l in lpgRows) {
      buffer.writeln('${l.locationKey},${l.cylinders},${l.weight},${l.annualTons.toStringAsFixed(3)}');
    }
    buffer.writeln('');
    buffer.writeln('5. PAPER USAGE LEDGER');
    buffer.writeln('Department,Annual Reams,Annual (tCO2e)');
    for (var p in paperDeptRows) {
      buffer.writeln('${p.department},${p.annualReams},${p.annualTons.toStringAsFixed(3)}');
    }
    buffer.writeln('Student Headcount Paper Baseline,,${studentPaperTonsAnnual.toStringAsFixed(3)}');
    buffer.writeln('');
    buffer.writeln('6. SOLAR PV CLEAN OFFSETS');
    buffer.writeln('Array Name,Capacity (kW),Monthly Generation (kWh),Annual Offset (tCO2e)');
    for (var s in solarRows) {
      buffer.writeln('${s.name},${s.capacityKw},${s.monthlyGenerationKwh},${s.annualOffsetTons.toStringAsFixed(3)}');
    }
    buffer.writeln('');
    buffer.writeln('7. NATIVE TREE CARBON SINKS');
    buffer.writeln('Species,Tree Count,Absorption Rate (kg/tree/yr),Annual Offset (tCO2e)');
    for (var t in treeRows) {
      buffer.writeln('${t.speciesKey},${t.treeCount},${t.absorptionRate},${t.annualOffsetTons.toStringAsFixed(3)}');
    }
    buffer.writeln('');
    buffer.writeln('8. WASTE RECYCLING OFFSETS');
    buffer.writeln('Material,Monthly Recycled (kg),Factor (kg/kg),Annual Offset (tCO2e)');
    for (var w in wasteRows) {
      buffer.writeln('${w.materialKey},${w.monthlyRecycledKg},${w.factor},${w.annualOffsetTons.toStringAsFixed(3)}');
    }
    return buffer.toString();
  }
}
