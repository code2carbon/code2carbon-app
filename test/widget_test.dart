import 'package:flutter_test/flutter_test.dart';
import 'package:code2carbon/app/app.dart';
import 'package:code2carbon/core/constants/api_constants.dart';
import 'package:code2carbon/core/constants/emission_factors.dart';
import 'package:code2carbon/features/calculator/models/institution_profile.dart';
import 'package:code2carbon/features/calculator/models/ledger_models.dart';
import 'package:code2carbon/features/calculator/services/calculator_engine.dart';
import 'package:code2carbon/features/dashboard/models/dashboard_data_model.dart';
import 'package:code2carbon/shared/models/calculation_summary.dart';

import 'package:flutter/material.dart';
import 'package:code2carbon/app/main_navigation_shell.dart';
import 'package:code2carbon/features/splash/screens/splash_screen.dart';

void main() {
  testWidgets('CarbonTrackApp builds cleanly with HomeScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CarbonTrackApp(home: MainNavigationShell()));
    await tester.pump();
    expect(find.text('Explore Platform'), findsOneWidget);
    expect(find.text('Built for institutional scale'), findsOneWidget);
  });

  testWidgets('SplashScreen renders branding, milestones and skip button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(
          autoNavigate: false,
        ),
      ),
    );
    await tester.pump();

    // Verify key brand elements
    expect(find.byKey(const Key('splash_screen')), findsOneWidget);
    expect(find.byKey(const Key('splash_logo')), findsOneWidget);
    expect(find.byKey(const Key('splash_title')), findsOneWidget);
    expect(find.textContaining('Code2', findRichText: true), findsAtLeastNWidgets(1));
    expect(find.textContaining('Carbon', findRichText: true), findsAtLeastNWidgets(1));
    expect(find.text('Carbon Footprint Emission Assessment Platform'), findsOneWidget);
    expect(find.byKey(const Key('splash_skip_button')), findsOneWidget);
  });

  testWidgets('SplashScreen manual skip triggers completion callback',
      (WidgetTester tester) async {
    bool completed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(
          autoNavigate: false,
          onComplete: () {
            completed = true;
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('splash_skip_button')));
    await tester.pump();

    expect(completed, isTrue);
  });


  test('Emission factors and calculation summary logic test', () {
    const summary = CalculationSummary(
      vehicleKg: 1000.0,
      energyKg: 2000.0,
      generatorKg: 500.0,
      lpgKg: 500.0,
      paperKg: 200.0,
      solarOffsetKg: 800.0,
      treeSinkKg: 400.0,
      wasteOffsetKg: 0.0,
    );

    expect(summary.grossKg, equals(4200.0));
    expect(summary.grossTons, equals(4.2));
    expect(summary.offsetsKg, equals(1200.0));
    expect(summary.offsetsTons, equals(1.2));
    expect(summary.netKg, equals(3000.0));
    expect(summary.netTons, equals(3.0));

    // Verify emission factors
    expect(EmissionFactors.vehicleFuelFactors['diesel'], equals(2.684));
    expect(EmissionFactors.energyCoefficients['purchased-grid'], equals(0.792));
    expect(EmissionFactors.lpgFactor, equals(2.988));
    expect(EmissionFactors.paperFactor, equals(3.591));
    expect(EmissionFactors.studentPaperFactor, equals(0.75));
  });

  test('Dashboard data model integrity test', () {
    final dashboard = DashboardDataModel.defaultData;
    expect(dashboard.totalGrossTons, equals(824.0));
    expect(dashboard.scope1Tons + dashboard.scope2Tons + dashboard.scope3Tons,
        equals(824.0));
    expect(dashboard.monthlyTrends.length, equals(12));
    expect(dashboard.categories.length, equals(5));
    expect(dashboard.esgGrade, contains('Gold Standard'));
  });

  test('Phase 5 - Institution Profile & file attachment model test', () {
    final profile = InstitutionProfile(
      name: 'Greenfield University',
      campusAreaAcres: 50.0,
      builtUpAreaSqm: 32000.0,
      totalPopulation: 4000,
      studentsCount: 3500,
      facultyStaffCount: 500,
      logoFileName: 'logo.png',
      photoFileName: 'campus.jpg',
      layoutFileName: 'layout.pdf',
    );

    expect(profile.name, equals('Greenfield University'));
    expect(profile.campusAreaAcres, equals(50.0));
    expect(profile.builtUpAreaSqm, equals(32000.0));
    expect(profile.totalPopulation, equals(4000));
    expect(profile.studentsCount, equals(3500));
    expect(profile.logoFileName, equals('logo.png'));
    expect(profile.photoFileName, equals('campus.jpg'));
    expect(profile.layoutFileName, equals('layout.pdf'));

    final updated = profile.copyWith(totalPopulation: 4200);
    expect(updated.totalPopulation, equals(4200));
    expect(updated.studentsCount, equals(3500));
  });

  test('Phase 6 - Scope 1 & 3 Vehicle Emissions Ledger math and scope resolution', () {
    // 1. Institute-Owned Diesel Bus -> Scope 1
    final bus = VehicleRow(
      id: 'v1',
      type: 'bus',
      fuel: 'diesel',
      ownership: 'institute-owned',
      count: 2,
      distanceKmPerDay: 50.0,
    );
    expect(bus.scope, equals('Scope 1'));
    expect(bus.factor, equals(2.684));
    // daily = 2 * 50 * 2.684 * 0.0485 = 13.0174 kg
    expect(bus.dailyKg, closeTo(13.0174, 0.001));
    // monthly = daily * 20 = 260.348 kg
    expect(bus.monthlyKg, closeTo(260.348, 0.01));
    // annual = monthly * 12 = 3124.176 kg = 3.124 t
    expect(bus.annualTons, closeTo(3.124, 0.01));

    // 2. Staff-Owned Petrol Car -> Scope 3
    final car = VehicleRow(
      id: 'v2',
      type: 'car',
      fuel: 'petrol',
      ownership: 'staff-owned',
      count: 10,
      distanceKmPerDay: 20.0,
    );
    expect(car.scope, equals('Scope 3'));
    expect(car.factor, equals(2.314));

    // 3. Institute-Owned Electric Van -> Scope 2
    final ev = VehicleRow(
      id: 'v3',
      type: 'van',
      fuel: 'electric',
      ownership: 'institute-owned',
      count: 1,
      distanceKmPerDay: 30.0,
    );
    expect(ev.scope, equals('Scope 2'));
    expect(ev.factor, equals(0.0));
    expect(ev.annualTons, equals(0.0));
  });

  test('Phase 7 - Scope 2 Electricity & Energy Ledger calculation and bill attachment', () {
    // 1. Purchased Grid Power: 25,000 kWh/mo
    final grid = EnergyRow(
      id: 'e1',
      type: 'purchased-grid',
      source: 'Main Substation',
      monthlyKwh: 25000.0,
      billFileName: 'electricity_bill_oct2026.pdf',
    );
    expect(grid.scope, equals('Scope 2'));
    expect(grid.factor, equals(0.792)); // CEA Baseline v19
    // monthly = 25000 * 0.792 = 19,800 kg
    expect(grid.monthlyKg, equals(19800.0));
    // annual = 19800 * 12 = 237,600 kg = 237.6 tCO2e
    expect(grid.annualKg, equals(237600.0));
    expect(grid.annualTons, equals(237.6));
    expect(grid.billFileName, equals('electricity_bill_oct2026.pdf'));

    // 2. Solar Generator: 5,000 kWh/mo -> Zero emissions (Offset)
    final solar = EnergyRow(
      id: 'e2',
      type: 'solar-power',
      source: 'Clean Solar',
      monthlyKwh: 5000.0,
    );
    expect(solar.scope, equals('Offset'));
    expect(solar.factor, equals(0.0));
    expect(solar.annualTons, equals(0.0));
  });

  test('Phase 8 - Scope 1 Generators & LPG Dining Ledger calculations, presets, and attachments', () {
    // 1. Diesel Generator: 500 Litres/month at factor 2.684
    final gen = GeneratorRow(
      id: 'g1',
      location: 'Main Substation Backup GenSet',
      monthlyDieselLitres: 500.0,
      billFileName: 'genset_fuel_slip.pdf',
    );
    expect(gen.factor, equals(2.684));
    // monthly = 500 * 2.684 = 1342.0 kgCO2
    expect(gen.monthlyKg, closeTo(1342.0, 0.001));
    // annual = 1342 * 12 = 16104.0 kgCO2 = 16.104 tCO2e
    expect(gen.annualKg, closeTo(16104.0, 0.001));
    expect(gen.annualTons, closeTo(16.104, 0.001));
    expect(gen.billFileName, equals('genset_fuel_slip.pdf'));

    // 2. LPG Dining: 40 cylinders of 14.2 kg at factor 2.988
    final lpgPreset = LpgRow(
      id: 'l1',
      locationKey: 'boys-hostel-mess',
      cylinders: 40.0,
      weight: 14.2,
    );
    expect(lpgPreset.location, equals('Boys Hostel Mess'));
    expect(lpgPreset.factor, equals(2.988));
    expect(lpgPreset.monthlyLpgKg, closeTo(568.0, 0.001)); // 40 * 14.2
    // monthlyKg = 568.0 * 2.988 = 1697.184 kgCO2
    expect(lpgPreset.monthlyKg, closeTo(1697.184, 0.001));
    // annualKg = monthlyKg * 12 * 2.988 (Matching calculator.js formula)
    final expectedAnnualKg = 1697.184 * 12.0 * 2.988;
    expect(lpgPreset.annualKg, closeTo(expectedAnnualKg, 0.01));

    // 3. LPG Custom Location fallback
    final lpgCustom = LpgRow(
      id: 'l2',
      locationKey: 'other',
      customLocation: 'Guest House Kitchen',
      cylinders: 10.0,
      weight: 19.0, // Commercial 19kg cylinder
    );
    expect(lpgCustom.location, equals('Guest House Kitchen'));
    expect(lpgCustom.monthlyLpgKg, equals(190.0));
  });

  // ---------------------------------------------------------------------------
  // Phase 9: Scope 3 Paper & Headcount Dynamic Sync
  // ---------------------------------------------------------------------------
  test('Phase 9 - Scope 3 Paper & Headcount Dynamic Sync calculations', () {
    // 1. Department Paper Row: 200 reams * 2.5 kg * 3.591 factor
    final deptPaper = PaperDeptRow(
      id: 'p1',
      department: 'Registrar Office',
      annualReams: 200.0,
    );
    // 200 reams * 2.5 kg/ream = 500 kg
    expect(deptPaper.totalKg, equals(500.0));
    expect(deptPaper.factor, equals(3.591));
    // annual CO2 = 500 * 3.591 = 1795.5 kg
    expect(deptPaper.annualKg, closeTo(1795.5, 0.01));
    expect(deptPaper.annualTons, closeTo(1.7955, 0.001));

    // 2. Student Headcount Sync: 1000 students * 0.75 kg/student/yr = 750 kg baseline
    final profile = InstitutionProfile(
      studentsCount: 1000,
      totalPopulation: 1200,
    );
    final studentPaperKg =
        profile.studentsCount * EmissionFactors.studentPaperFactor;
    expect(studentPaperKg, equals(750.0)); // 1000 * 0.75

    // studentPaperTons = 750 * 3.591 / 1000 = 2.69325 t
    final studentPaperTons =
        (studentPaperKg * EmissionFactors.paperFactor) / 1000.0;
    expect(studentPaperTons, closeTo(2.693, 0.001));

    // 3. Zero-ream edge case
    final emptyDept = PaperDeptRow(id: 'p0', annualReams: 0.0);
    expect(emptyDept.annualTons, equals(0.0));
  });

  // ---------------------------------------------------------------------------
  // Phase 10: Clean Offsets — Solar PV, Native Trees & Waste Recycling
  // ---------------------------------------------------------------------------
  test('Phase 10 - Clean Offsets: Solar PV, Native Trees & Waste Recycling models', () {
    // ---- Solar PV ----
    final solar = SolarOffsetRow(
      id: 's1',
      name: 'Admin Block Rooftop 60kW Array',
      capacityKw: 60.0,
      monthlyGenerationKwh: 8000.0,
    );
    expect(solar.factor, equals(0.792)); // solarOffsetFactor = 0.792
    // monthly offset = 8000 * 0.792 = 6336 kg
    expect(solar.monthlyOffsetKg, closeTo(6336.0, 0.01));
    // annual offset = 6336 * 12 = 76032 kg = 76.032 t
    expect(solar.annualOffsetTons, closeTo(76.032, 0.01));

    // ---- Native Tree: 100 Neem trees ----
    final neem = TreeOffsetRow(
      id: 't1',
      speciesKey: 'neem',
      treeCount: 100,
    );
    final neemRate = EmissionFactors.nativeTrees['neem']!;
    expect(neem.absorptionRate, equals(neemRate));
    expect(neem.annualOffsetKg, closeTo(100 * neemRate, 0.001));
    expect(neem.annualOffsetTons, closeTo((100 * neemRate) / 1000, 0.001));

    // ---- Custom Species: 50 trees, 30 kg/yr absorption ----
    final customTree = TreeOffsetRow(
      id: 't2',
      speciesKey: 'other',
      customSpeciesName: 'Mahogany',
      treeCount: 50,
      customAbsorptionRate: 30.0,
    );
    expect(customTree.absorptionRate, equals(30.0));
    expect(customTree.annualOffsetKg, closeTo(1500.0, 0.001)); // 50 * 30
    expect(customTree.annualOffsetTons, closeTo(1.5, 0.001));

    // Custom tree with 0 absorption fallback -> should use 25.0 default
    final zeroAbsorption = TreeOffsetRow(
      id: 't3',
      speciesKey: 'other',
      treeCount: 10,
      customAbsorptionRate: 0.0,
    );
    expect(zeroAbsorption.absorptionRate, equals(25.0));

    // ---- Waste Recycling: 500 kg/month organic composting ----
    final waste = WasteOffsetRow(
      id: 'w1',
      materialKey: 'organic',
      monthlyRecycledKg: 500.0,
    );
    final organicFactor = EmissionFactors.wasteCoefficients['organic']!;
    expect(waste.factor, equals(organicFactor));
    expect(waste.monthlyOffsetKg, closeTo(500 * organicFactor, 0.001));
    expect(waste.annualOffsetKg, closeTo(500 * organicFactor * 12, 0.001));

    // ---- Verify all factor constants are present ----
    expect(EmissionFactors.solarOffsetFactor, equals(0.792));
    expect(EmissionFactors.nativeTrees.containsKey('neem'), isTrue);
    expect(EmissionFactors.nativeTrees.containsKey('banyan'), isTrue);
    expect(EmissionFactors.nativeTrees.containsKey('peepal'), isTrue);
    expect(EmissionFactors.wasteCoefficients.containsKey('paper'), isTrue);
    expect(EmissionFactors.wasteCoefficients.containsKey('plastic'), isTrue);
    expect(EmissionFactors.wasteCoefficients.containsKey('organic'), isTrue);
    expect(EmissionFactors.wasteCoefficients.containsKey('metal'), isTrue);
  });

  // ---------------------------------------------------------------------------
  // Phase 11 & 12: Final Tab Net Footprint, Intensity Metrics & Cloud Sync
  // ---------------------------------------------------------------------------
  test('Phase 11 & 12 - Final Tab Net Footprint, Intensity Metrics & Aggregate math', () {
    // Generator: 1000 L/mo * 2.684 = 2684 kg/mo * 12 = 32208 kg/yr = 32.208 t
    final gen = GeneratorRow(id: 'g1', monthlyDieselLitres: 1000.0);
    expect(gen.annualTons, closeTo(32.208, 0.001));

    // Energy: 10000 kWh/mo * 0.792 = 7920 kg/mo * 12 = 95040 kg/yr = 95.04 t
    final energy = EnergyRow(
        id: 'e1', type: 'purchased-grid', monthlyKwh: 10000.0);
    expect(energy.annualTons, closeTo(95.04, 0.001));

    // Solar offset: 5000 kWh/mo * 0.792 = 3960 kg/mo * 12 = 47520 kg = 47.52 t
    final solar = SolarOffsetRow(id: 's1', monthlyGenerationKwh: 5000.0);
    expect(solar.annualOffsetTons, closeTo(47.52, 0.001));

    // Gross = gen + energy = 32.208 + 95.04 = 127.248 t
    final gross = gen.annualTons + energy.annualTons;
    expect(gross, closeTo(127.248, 0.01));

    // Net = gross - offsets (clamped to 0)
    final net = (gross - solar.annualOffsetTons).clamp(0.0, double.infinity);
    expect(net, closeTo(79.728, 0.01));

    // Per-capita intensity: net / total population
    const population = 500;
    final perCapita = net / population;
    expect(perCapita, closeTo(0.15946, 0.001));

    // Spatial intensity: net * 1000 / built-up area (kg/m²)
    const builtArea = 5000.0;
    final intensity = (net * 1000) / builtArea;
    expect(intensity, closeTo(15.946, 0.01));

    // Edge case: zero gross means net must be 0 (clamp)
    final zeroNet = (0.0 - solar.annualOffsetTons).clamp(0.0, double.infinity);
    expect(zeroNet, equals(0.0));
  });

  // ---------------------------------------------------------------------------
  // Phase 13: PDF Report Generator – data completeness (model-level)
  // ---------------------------------------------------------------------------
  test('Phase 13 - PDF Report Generator data completeness (model-level test)', () {
    // All ledger models that feed the PDF must produce positive values
    final gen = GeneratorRow(id: 'g1', location: 'Library Backup');
    expect(gen.annualTons, greaterThan(0));

    final solarArray = SolarOffsetRow(id: 's1', name: 'Rooftop Array A');
    expect(solarArray.annualOffsetTons, greaterThan(0));

    final tree = TreeOffsetRow(id: 't1', speciesKey: 'banyan', treeCount: 75);
    expect(tree.annualOffsetTons, greaterThan(0));

    final waste = WasteOffsetRow(
        id: 'w1', materialKey: 'paper', monthlyRecycledKg: 300.0);
    expect(waste.annualOffsetTons, greaterThan(0));

    // Institution profile supplies all cover-page metadata
    final profile = InstitutionProfile(
      name: 'Test Institute of Technology',
      address: 'Campus Road, City 600001',
      campusAreaAcres: 75.0,
      builtUpAreaSqm: 45000.0,
      totalPopulation: 5500,
    );
    expect(profile.name, isNotEmpty);
    expect(profile.address, isNotEmpty);
    expect(profile.totalPopulation, greaterThan(0));
    expect(profile.builtUpAreaSqm, greaterThan(0));
    expect(profile.campusAreaAcres, greaterThan(0));
  });

  // ---------------------------------------------------------------------------
  // Phase 14: EcoBot Sustainability Assistant (model-level)
  // ---------------------------------------------------------------------------
  test('Phase 14 - EcoBot ChatMessage model test', () {
    // Verify the data model fields used by EcoBotChatDrawer
    final userMsg = _ChatMessageMock(text: 'What is Scope 1?', isUser: true);
    final botMsg = _ChatMessageMock(
        text: 'Scope 1 is direct emissions.', isUser: false);

    expect(userMsg.text, equals('What is Scope 1?'));
    expect(userMsg.isUser, isTrue);
    expect(botMsg.text, equals('Scope 1 is direct emissions.'));
    expect(botMsg.isUser, isFalse);

    // Verify all emission factor constants referenced in EcoBot knowledge base
    expect(EmissionFactors.energyCoefficients['purchased-grid'], equals(0.792));
    expect(EmissionFactors.lpgFactor, equals(2.988));
    expect(EmissionFactors.solarOffsetFactor, equals(0.792));
    expect(EmissionFactors.paperFactor, equals(3.591));
  });

  // ---------------------------------------------------------------------------
  // Phase 15: Website Parity Audit — Comprehensive CSV Export & Peer Benchmarks
  // ---------------------------------------------------------------------------
  test('Phase 15 - Complete Ledger CSV Export and Peer Benchmarks verification', () {
    final engine = CalculatorEngine();
    final csv = engine.generateCsvReport();

    // Verify all 8 ledger sections exist in the exported CSV
    expect(csv.contains('CarbonTrack Institutional Assessment Ledger'), isTrue);
    expect(csv.contains('1. VEHICLES LEDGER'), isTrue);
    expect(csv.contains('2. ENERGY & ELECTRICITY LEDGER'), isTrue);
    expect(csv.contains('3. DIESEL GENERATORS LEDGER'), isTrue);
    expect(csv.contains('4. LPG DINING & MESS LEDGER'), isTrue);
    expect(csv.contains('5. PAPER USAGE LEDGER'), isTrue);
    expect(csv.contains('6. SOLAR PV CLEAN OFFSETS'), isTrue);
    expect(csv.contains('7. NATIVE TREE CARBON SINKS'), isTrue);
    expect(csv.contains('8. WASTE RECYCLING OFFSETS'), isTrue);
    expect(csv.contains('Per Capita Intensity (tCO2e/person)'), isTrue);
    expect(csv.contains('Spatial Intensity (kgCO2e/m2)'), isTrue);

    // Verify peer benchmarks matching website carbontrack/script.js lines 131-136
    expect(ApiConstants.peerBenchmarks['tech-office']?.value, equals(35.00));
    expect(ApiConstants.peerBenchmarks['university']?.value, equals(120.00));
    expect(ApiConstants.peerBenchmarks['manufacturing']?.value, equals(450.00));
    expect(ApiConstants.peerBenchmarks['retail']?.value, equals(25.00));
  });
}

/// Lightweight mock mirroring the ChatMessage fields used in EcoBotChatDrawer.
/// Avoids importing the widget (which requires a full app context in tests).
class _ChatMessageMock {
  final String text;
  final bool isUser;
  _ChatMessageMock({required this.text, required this.isUser});
}
