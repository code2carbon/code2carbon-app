/// API & Supabase Connection Constants
/// Reuses the existing backend configurations from carbontrack and supabase/README.md
class ApiConstants {
  static const String supabaseUrl = "https://ifwnhzjfwluqjhsfykbw.supabase.co";
  static const String supabaseAnonKey =
      "sb_publishable_dDgGIa04mh20YFU1PbGSsw_M0l6mfjG";

  // Edge Functions
  static const String generateInsightsFunction = "generate-insights";

  // Database Tables
  static const String emissionsSubmissionsTable = "emissions_submissions";

  // Peer Benchmarks (tCO2e per year standard)
  static const Map<String, ({String name, double value})> peerBenchmarks = {
    'tech-office': (name: 'Tech Office', value: 35.00),
    'university': (name: 'University Campus', value: 120.00),
    'manufacturing': (name: 'Manufacturing', value: 450.00),
    'retail': (name: 'Retail Store', value: 25.00),
  };
}
