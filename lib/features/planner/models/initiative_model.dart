import '../../../app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Net-Zero Mitigation Initiative Model
class InitiativeModel {
  final String id;
  final String title;
  final String description;
  final String scopeLabel;
  final Color scopeColor;
  final double capEx;
  final double paybackYears;
  final String impactText;
  final double savingsTons; // Estimated annual carbon reduction
  bool isSelected;

  InitiativeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.scopeLabel,
    required this.scopeColor,
    required this.capEx,
    required this.paybackYears,
    required this.impactText,
    required this.savingsTons,
    this.isSelected = false,
  });

  static List<InitiativeModel> get defaultInitiatives => [
        InitiativeModel(
          id: 'solar',
          title: 'Solar Rooftop Array (50 kW)',
          description:
              'Install on-site photovoltaic solar panels to offset grid electricity consumption.',
          scopeLabel: 'Scope 2',
          scopeColor: AppColors.scope2,
          capEx: 45000,
          paybackYears: 5.0,
          impactText: '-30% Electricity',
          savingsTons: 11.85,
          isSelected: true,
        ),
        InitiativeModel(
          id: 'ev',
          title: 'EV Campus Fleet Transition',
          description:
              'Replace gasoline and diesel shuttle buses and facilities vehicles with electric models.',
          scopeLabel: 'Scope 1',
          scopeColor: AppColors.scope1,
          capEx: 60000,
          paybackYears: 6.0,
          impactText: '-80% Fleet Fuel',
          savingsTons: 9.60,
          isSelected: false,
        ),
        InitiativeModel(
          id: 'led',
          title: 'LED Lighting & HVAC Retrofit',
          description:
              'Upgrade campus buildings to smart LED fixtures and energy-efficient HVAC units.',
          scopeLabel: 'Scope 2',
          scopeColor: AppColors.scope2,
          capEx: 15000,
          paybackYears: 3.5,
          impactText: '-15% Electricity',
          savingsTons: 5.92,
          isSelected: true,
        ),
        InitiativeModel(
          id: 'waste',
          title: 'Zero-Waste Composting & Recycling',
          description:
              'Establish on-campus waste composting and enhanced recycling flow systems.',
          scopeLabel: 'Scope 3',
          scopeColor: AppColors.scope3,
          capEx: 8000,
          paybackYears: 2.0,
          impactText: '-60% Waste',
          savingsTons: 1.80,
          isSelected: false,
        ),
        InitiativeModel(
          id: 'paper',
          title: 'Paperless Campus Transition',
          description:
              'Transition to 100% digital administration, exams, and paperless class materials.',
          scopeLabel: 'Scope 3',
          scopeColor: AppColors.scope3,
          capEx: 3000,
          paybackYears: 1.0,
          impactText: '-90% Paper',
          savingsTons: 3.88,
          isSelected: true,
        ),
      ];
}
