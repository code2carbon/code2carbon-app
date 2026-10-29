import '../../../core/constants/emission_factors.dart';

/// 1. Vehicle Row Model
class VehicleRow {
  String id;
  String type; // car, bus, van, bike, truck, auto-rickshaw
  String fuel; // petrol, diesel, cng, electric
  String ownership; // institute-owned, staff-owned, student-owned, other
  double count;
  double distanceKmPerDay;

  VehicleRow({
    required this.id,
    this.type = 'car',
    this.fuel = 'petrol',
    this.ownership = 'institute-owned',
    this.count = 1,
    this.distanceKmPerDay = 25.0,
  });

  double get factor => EmissionFactors.vehicleFuelFactors[fuel] ?? 2.314;

  String get scope {
    if (ownership == 'institute-owned') {
      return fuel == 'electric' ? 'Scope 2' : 'Scope 1';
    }
    return 'Scope 3';
  }

  // Daily Emission = Count × Distance × Emission Factor × 0.0485
  double get dailyKg => count * distanceKmPerDay * factor * EmissionFactors.vehicleDayFactor;

  // Monthly Emission = Daily × 20 working days
  double get monthlyKg => dailyKg * EmissionFactors.vehicleWorkingDaysPerMonth;

  // Annual Emission = Monthly × 12 months
  double get annualKg => monthlyKg * EmissionFactors.vehicleMonthsPerYear;
  double get annualTons => annualKg / 1000.0;
}

/// 2. Energy Row Model
class EnergyRow {
  String id;
  String type; // purchased-grid, coal-power, natural-gas, solar-power, wind-power
  String source;
  double monthlyKwh;
  String? billAttachmentPath;
  String? billFileName;

  EnergyRow({
    required this.id,
    this.type = 'purchased-grid',
    this.source = 'Grid utility',
    this.monthlyKwh = 12500.0,
    this.billAttachmentPath,
    this.billFileName,
  });

  double get factor => EmissionFactors.energyCoefficients[type] ?? 0.792;

  String get scope {
    if (type == 'solar-power' || type == 'wind-power') return 'Offset';
    return 'Scope 2';
  }

  double get monthlyKg => monthlyKwh * factor;
  double get annualKg => monthlyKg * 12.0;
  double get annualTons => annualKg / 1000.0;
}

/// 3. Diesel Generator Row Model
class GeneratorRow {
  String id;
  String location;
  double monthlyDieselLitres;
  String? billAttachmentPath;
  String? billFileName;

  GeneratorRow({
    required this.id,
    this.location = 'Main Campus Substation',
    this.monthlyDieselLitres = 450.0,
    this.billAttachmentPath,
    this.billFileName,
  });

  double get factor => EmissionFactors.dieselGeneratorFactor; // 2.684
  double get monthlyKg => monthlyDieselLitres * factor;
  double get annualKg => monthlyKg * 12.0;
  double get annualTons => annualKg / 1000.0;
}

/// 4. LPG Dining & Mess Row Model
class LpgRow {
  String id;
  String locationKey; // 'girls-hostel-mess', 'boys-hostel-mess', 'canteen', 'private', 'other'
  String customLocation;
  double cylinders;
  double weight;

  LpgRow({
    required this.id,
    String? location,
    this.locationKey = 'girls-hostel-mess',
    this.customLocation = '',
    this.cylinders = 35.0,
    this.weight = 14.2,
    double? monthlyLpgKg,
  }) {
    if (location != null) {
      if (['girls-hostel-mess', 'boys-hostel-mess', 'canteen', 'private', 'other'].contains(location)) {
        locationKey = location;
      } else {
        locationKey = 'other';
        customLocation = location;
      }
    }
    if (monthlyLpgKg != null && monthlyLpgKg > 0) {
      weight = 14.2;
      cylinders = monthlyLpgKg / 14.2;
    }
  }

  String get location {
    switch (locationKey) {
      case 'girls-hostel-mess':
        return 'Girls Hostel Mess';
      case 'boys-hostel-mess':
        return 'Boys Hostel Mess';
      case 'canteen':
        return 'Canteen';
      case 'private':
        return 'Private Kitchen';
      case 'other':
      default:
        return customLocation.isNotEmpty ? customLocation : 'Other Facility';
    }
  }

  set location(String val) {
    if (['girls-hostel-mess', 'boys-hostel-mess', 'canteen', 'private', 'other'].contains(val)) {
      locationKey = val;
    } else {
      locationKey = 'other';
      customLocation = val;
    }
  }

  double get monthlyLpgKg => cylinders * weight;
  set monthlyLpgKg(double val) {
    weight = 14.2;
    cylinders = val / 14.2;
  }

  double get factor => EmissionFactors.lpgFactor; // 2.988

  // Monthly Emission = Number of Cylinders × Cylinder Weight × 2.988
  double get monthlyKg => cylinders * weight * factor;

  // Annual Emission = Monthly × 12 × 2.988 (Matches website formula in calculator.js line 589 & 1141)
  double get annualKg => monthlyKg * 12.0 * factor;
  double get annualTons => annualKg / 1000.0;
}

/// 5. Paper Usage Model
class PaperDeptRow {
  String id;
  String department;
  double annualReams; // 1 ream = 2.5 kg

  PaperDeptRow({
    required this.id,
    this.department = 'Administrative Block',
    this.annualReams = 120.0,
  });

  double get totalKg => annualReams * 2.5;
  double get factor => EmissionFactors.paperFactor; // 3.591
  double get annualKg => totalKg * factor;
  double get annualTons => annualKg / 1000.0;
}

/// 6. Solar Rooftop PV Offset Model
class SolarOffsetRow {
  String id;
  String name;
  double capacityKw;
  double monthlyGenerationKwh;

  SolarOffsetRow({
    required this.id,
    this.name = 'Science Wing Rooftop Array',
    this.capacityKw = 50.0,
    this.monthlyGenerationKwh = 6200.0,
  });

  double get factor => EmissionFactors.solarOffsetFactor; // 0.792
  double get monthlyOffsetKg => monthlyGenerationKwh * factor;
  double get annualOffsetKg => monthlyOffsetKg * 12.0;
  double get annualOffsetTons => annualOffsetKg / 1000.0;
}

/// 7. Native Tree Offset Model
class TreeOffsetRow {
  String id;
  String speciesKey; // cluster-fig, banyan, neem, etc. or 'other'
  String customSpeciesName;
  int treeCount;
  double customAbsorptionRate;

  TreeOffsetRow({
    required this.id,
    this.speciesKey = 'neem',
    this.customSpeciesName = '',
    this.treeCount = 85,
    this.customAbsorptionRate = 52.5,
  });

  double get absorptionRate {
    if (speciesKey == 'other') {
      return customAbsorptionRate > 0 ? customAbsorptionRate : 25.0;
    }
    return EmissionFactors.nativeTrees[speciesKey] ??
        EmissionFactors.otherTrees[speciesKey] ??
        25.0;
  }

  double get annualOffsetKg => treeCount * absorptionRate;
  double get annualOffsetTons => annualOffsetKg / 1000.0;
}

/// 8. Waste Recycling Offset Model
class WasteOffsetRow {
  String id;
  String materialKey; // paper, plastic, organic, metal, etc.
  double monthlyRecycledKg;

  WasteOffsetRow({
    required this.id,
    this.materialKey = 'paper',
    this.monthlyRecycledKg = 350.0,
  });

  double get factor => EmissionFactors.wasteCoefficients[materialKey] ?? 1.37;
  double get monthlyOffsetKg => monthlyRecycledKg * factor;
  double get annualOffsetKg => monthlyOffsetKg * 12.0;
  double get annualOffsetTons => annualOffsetKg / 1000.0;
}
