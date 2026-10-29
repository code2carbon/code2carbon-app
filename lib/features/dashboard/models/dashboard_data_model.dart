import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

/// Monthly emission record for trends
class MonthlyEmissionPoint {
  final String month;
  final double emissionsTons;

  const MonthlyEmissionPoint({
    required this.month,
    required this.emissionsTons,
  });
}

/// Category source item for hotspot breakdown
class EmissionCategoryItem {
  final String name;
  final String scope;
  final Color scopeColor;
  final IconData icon;
  final double tons;
  final double percentage;

  const EmissionCategoryItem({
    required this.name,
    required this.scope,
    required this.scopeColor,
    required this.icon,
    required this.tons,
    required this.percentage,
  });
}

/// Master Dashboard Data Model
class DashboardDataModel {
  final double totalGrossTons;
  final double totalNetTons;
  final double totalOffsetsTons;
  final double scope1Tons;
  final double scope2Tons;
  final double scope3Tons;

  // YoY % changes
  final double grossYoyPct;
  final double scope1YoyPct;
  final double scope2YoyPct;
  final double scope3YoyPct;

  // Intensity Metrics
  final double perCapitaTons;
  final double perSqmKg;
  final String esgGrade;
  final int totalPopulation;
  final double builtUpAreaSqm;

  final List<MonthlyEmissionPoint> monthlyTrends;
  final List<EmissionCategoryItem> categories;

  const DashboardDataModel({
    required this.totalGrossTons,
    required this.totalNetTons,
    required this.totalOffsetsTons,
    required this.scope1Tons,
    required this.scope2Tons,
    required this.scope3Tons,
    required this.grossYoyPct,
    required this.scope1YoyPct,
    required this.scope2YoyPct,
    required this.scope3YoyPct,
    required this.perCapitaTons,
    required this.perSqmKg,
    required this.esgGrade,
    required this.totalPopulation,
    required this.builtUpAreaSqm,
    required this.monthlyTrends,
    required this.categories,
  });

  /// Default baseline data matching CarbonTrack reference inventory
  static DashboardDataModel get defaultData => const DashboardDataModel(
        totalGrossTons: 824.0,
        totalNetTons: 712.5,
        totalOffsetsTons: 111.5,
        scope1Tons: 231.0,
        scope2Tons: 387.0,
        scope3Tons: 206.0,
        grossYoyPct: -12.4,
        scope1YoyPct: 8.1,
        scope2YoyPct: -15.3,
        scope3YoyPct: -4.7,
        perCapitaTons: 0.23,
        perSqmKg: 28.5,
        esgGrade: 'A - Gold Standard',
        totalPopulation: 3500,
        builtUpAreaSqm: 28900.0,
        monthlyTrends: [
          MonthlyEmissionPoint(month: 'Jan', emissionsTons: 78.4),
          MonthlyEmissionPoint(month: 'Feb', emissionsTons: 74.2),
          MonthlyEmissionPoint(month: 'Mar', emissionsTons: 82.5),
          MonthlyEmissionPoint(month: 'Apr', emissionsTons: 68.9),
          MonthlyEmissionPoint(month: 'May', emissionsTons: 61.3),
          MonthlyEmissionPoint(month: 'Jun', emissionsTons: 54.0),
          MonthlyEmissionPoint(month: 'Jul', emissionsTons: 51.2),
          MonthlyEmissionPoint(month: 'Aug', emissionsTons: 58.7),
          MonthlyEmissionPoint(month: 'Sep', emissionsTons: 65.4),
          MonthlyEmissionPoint(month: 'Oct', emissionsTons: 71.0),
          MonthlyEmissionPoint(month: 'Nov', emissionsTons: 76.8),
          MonthlyEmissionPoint(month: 'Dec', emissionsTons: 81.6),
        ],
        categories: [
          EmissionCategoryItem(
            name: 'Purchased Grid Electricity',
            scope: 'Scope 2',
            scopeColor: AppColors.scope2,
            icon: Icons.bolt_rounded,
            tons: 387.0,
            percentage: 47.0,
          ),
          EmissionCategoryItem(
            name: 'Campus Shuttle & Fleet',
            scope: 'Scope 1 & 3',
            scopeColor: AppColors.scope1,
            icon: Icons.directions_bus_rounded,
            tons: 198.0,
            percentage: 24.0,
          ),
          EmissionCategoryItem(
            name: 'Diesel Backup Generators',
            scope: 'Scope 1',
            scopeColor: AppColors.scope1,
            icon: Icons.electrical_services_rounded,
            tons: 132.0,
            percentage: 16.0,
          ),
          EmissionCategoryItem(
            name: 'Dining Hall & Mess LPG',
            scope: 'Scope 1',
            scopeColor: AppColors.scope1,
            icon: Icons.outdoor_grill_rounded,
            tons: 66.0,
            percentage: 8.0,
          ),
          EmissionCategoryItem(
            name: 'Academic & Admin Paper',
            scope: 'Scope 3',
            scopeColor: AppColors.scope3,
            icon: Icons.menu_book_rounded,
            tons: 41.0,
            percentage: 5.0,
          ),
        ],
      );
}
