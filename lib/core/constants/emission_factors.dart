/// Authoritative greenhouse gas conversion coefficients
/// Derived from carbontrack/calculator.js, CEA India Baseline, and IPCC guidelines.
class EmissionFactors {
  // Vehicle Fuel Factors (kg CO2e per unit)
  static const Map<String, double> vehicleFuelFactors = {
    'petrol': 2.314,
    'diesel': 2.684,
    'cng': 2.314,
    'electric': 0.0,
  };

  // Vehicle Formula Multipliers
  static const double vehicleDayFactor = 0.0485;
  static const int vehicleWorkingDaysPerMonth = 20;
  static const int vehicleMonthsPerYear = 12;
  static const int vehicleWorkingDaysPerYear = 240;

  // Energy & Electricity Grid Coefficients (kg CO2e per kWh)
  static const Map<String, double> energyCoefficients = {
    'purchased-grid': 0.792, // CEA Baseline Database India
    'coal-power': 1.000,
    'natural-gas': 0.450,
    'solar-power': 0.000,
    'wind-power': 0.000,
  };

  // Diesel Generator (kg CO2e per Liter)
  static const double dieselGeneratorFactor = 2.684;

  // Liquefied Petroleum Gas (kg CO2e per kg)
  static const double lpgFactor = 2.988;

  // Paper Usage (kg CO2e per kg)
  static const double paperFactor = 3.591;

  // Student baseline paper consumption formula:
  // Students * 12 months * 125 sheets * 0.0005 kg = Students * 0.75 kg/yr
  static const double studentPaperFactor = 0.75;

  // Solar Clean Generation Offset (kg CO2e saved per kWh)
  static const double solarOffsetFactor = 0.792;

  // Native Tree Absorption Rates (kg CO2 absorbed per tree per year)
  static const Map<String, double> nativeTrees = {
    'cluster-fig': 45.0,
    'banyan': 60.0,
    'neem': 52.5,
    'peepal': 50.0,
    'almond': 42.5,
    'palm': 15.0,
    'rosewood': 32.5,
    'guava': 25.0,
    'ashoka': 25.0,
    'jasmine': 2.5,
    'thuja': 25.0,
    'tamarind': 37.5,
    'mango': 62.5,
    'coconut': 60.0,
    'gulmohar': 22.5,
    'potted-plants': 2.5,
  };

  // Extended Tree Database for custom entries
  static const Map<String, double> otherTrees = {
    'teak': 15.0,
    'oak': 22.0,
    'pine': 18.0,
    'eucalyptus': 25.0,
    'bamboo': 12.0,
    'mahogany': 23.0,
    'maple': 21.0,
    'birch': 16.0,
    'cedar': 15.0,
    'sandalwood': 10.0,
    'ash': 20.0,
    'elm': 22.0,
    'cherry': 14.0,
    'apple': 12.0,
    'jackfruit': 19.0,
    'ficus': 35.0,
    'acacia': 15.0,
    'rose': 0.5,
    'hibiscus': 1.0,
    'bougainvillea': 1.5,
    'cypress': 12.0,
    'fir': 15.0,
    'redwood': 45.0,
    'spruce': 14.0,
  };

  // Waste Recycling Avoided Emission Factors (kg CO2e saved per kg)
  static const Map<String, double> wasteCoefficients = {
    'paper': 1.37,
    'plastic': 1.80,
    'organic': 0.50,
    'metal': 8.50,
    'glass': 0.35,
    'ewaste': 2.20,
    'battery': 1.50,
    'biomedical': 0.20,
    'hazardous': 0.30,
  };
}
