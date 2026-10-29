import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/theme/app_colors.dart';
import '../services/calculator_engine.dart';
import '../widgets/docked_summary_bar.dart';
import '../widgets/energy_ledger_widget.dart';
import '../widgets/final_summary_tab.dart';
import '../widgets/generator_ledger_widget.dart';
import '../widgets/institution_profile_card.dart';
import '../widgets/lpg_ledger_widget.dart';
import '../widgets/paper_ledger_widget.dart';
import '../widgets/solar_offset_widget.dart';
import '../widgets/tree_offset_widget.dart';
import '../widgets/vehicle_ledger_widget.dart';
import '../widgets/waste_offset_widget.dart';

class CalculatorScreen extends StatefulWidget {
  final VoidCallback onOpenPdfReport;

  const CalculatorScreen({
    super.key,
    required this.onOpenPdfReport,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  int _selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<({String label, IconData icon})> _categories = const [
    (label: 'Profile', icon: Icons.apartment_rounded),
    (label: 'Vehicles', icon: Icons.directions_car_rounded),
    (label: 'Energy', icon: Icons.bolt_rounded),
    (label: 'Generators', icon: Icons.electrical_services_rounded),
    (label: 'LPG', icon: Icons.outdoor_grill_rounded),
    (label: 'Paper', icon: Icons.menu_book_rounded),
    (label: 'Solar', icon: Icons.solar_power_rounded),
    (label: 'Trees', icon: Icons.park_rounded),
    (label: 'Waste', icon: Icons.recycling_rounded),
    (label: 'Summary', icon: Icons.analytics_rounded),
  ];

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _exportCsv() {
    final csvData = CalculatorEngine().generateCsvReport();
    Share.share(
      csvData,
      subject: 'CarbonTrack Institutional Assessment Ledger.csv',
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activeContent;
    switch (_selectedCategoryIndex) {
      case 0:
        activeContent = const InstitutionProfileCard();
        break;
      case 1:
        activeContent = const VehicleLedgerWidget();
        break;
      case 2:
        activeContent = const EnergyLedgerWidget();
        break;
      case 3:
        activeContent = const GeneratorLedgerWidget();
        break;
      case 4:
        activeContent = const LpgLedgerWidget();
        break;
      case 5:
        activeContent = const PaperLedgerWidget();
        break;
      case 6:
        activeContent = const SolarOffsetWidget();
        break;
      case 7:
        activeContent = const TreeOffsetWidget();
        break;
      case 8:
        activeContent = const WasteOffsetWidget();
        break;
      case 9:
      default:
        activeContent = FinalSummaryTab(
          onOpenPdfReport: widget.onOpenPdfReport,
        );
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: Column(
        children: [
          // Elegant, eye-friendly pill category nav
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_categories.length, (index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: InkWell(
                      onTap: () => _onCategorySelected(index),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              cat.icon,
                              size: 14,
                              color: isSelected ? Colors.white : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              cat.label,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Thin divider
          Container(height: 1, color: AppColors.borderDivider),

          // Scrollable active content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: activeContent,
            ),
          ),

          // Sticky docked summary footer
          DockedSummaryBar(
            onOpenFinalTab: () => _onCategorySelected(9),
            onExportCsv: _exportCsv,
          ),
        ],
      ),
    );
  }
}
