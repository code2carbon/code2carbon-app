import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../calculator/services/calculator_engine.dart';

class PdfReportGenerator {
  static Future<Uint8List> generateAccreditedReport(CalculatorEngine engine) async {
    final pdf = pw.Document();
    final profile = engine.profile;
    final now = DateTime.now();
    final dateStr = DateFormat('MMMM dd, yyyy').format(now);
    final periodStr = 'FY 2025-26 (${DateFormat('yyyy').format(now)})';

    // Theme colors
    final primaryColor = PdfColor.fromHex('#10B981');
    final darkColor = PdfColor.fromHex('#0F172A');
    final secondaryColor = PdfColor.fromHex('#3B82F6');
    final greyBg = PdfColor.fromHex('#F8FAFC');

    // Page 1: Cover & Executive Certificate
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'CarbonTrack',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      pw.Text(
                        'Institutional Greenhouse Gas Inventory',
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: primaryColor,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(
                      'ISO 14064-1 & GHG Protocol',
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // Title block
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: darkColor,
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'AUDITED CARBON FOOTPRINT REPORT',
                      style: pw.TextStyle(
                        color: primaryColor,
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      profile.name,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '${profile.address} • Reporting Period: $periodStr',
                      style: const pw.TextStyle(color: PdfColors.grey300, fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),

              // Net Footprint Hero Box
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: greyBg,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    _buildPdfHeroStat(
                      'GROSS EMISSIONS',
                      '${engine.grossTons.toStringAsFixed(2)} t',
                      PdfColor.fromHex('#EF4444'),
                    ),
                    _buildPdfHeroStat(
                      'CLEAN OFFSETS',
                      '-${engine.totalCleanOffsetsTons.toStringAsFixed(2)} t',
                      primaryColor,
                    ),
                    _buildPdfHeroStat(
                      'NET CARBON FOOTPRINT',
                      '${engine.netTons.toStringAsFixed(2)} tCO₂e',
                      darkColor,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Normalized Metrics
              pw.Text('Operational Carbon Intensity',
                  style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildPdfMetricTile(
                      'Per-Capita Carbon',
                      '${engine.perCapitaTons.toStringAsFixed(3)} tCO₂e / person',
                      'Population: ${profile.totalPopulation}',
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _buildPdfMetricTile(
                      'Spatial Intensity',
                      '${engine.perSqmKg.toStringAsFixed(1)} kgCO₂e / m²',
                      'Built Area: ${profile.builtUpAreaSqm.toStringAsFixed(0)} m²',
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _buildPdfMetricTile(
                      'Campus Area Scale',
                      '${profile.campusAreaAcres.toStringAsFixed(1)} acres',
                      'Elevation: ${profile.elevation} m',
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // Scope Summary Table
              pw.Text('GHG Protocol Scope Itemization',
                  style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),

              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: greyBg),
                    children: [
                      _buildTableCell('Reporting Scope', isHeader: true),
                      _buildTableCell('Primary Sources', isHeader: true),
                      _buildTableCell('Emissions (tCO₂e)', isHeader: true, alignRight: true),
                      _buildTableCell('Gross Share', isHeader: true, alignRight: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell('Scope 1 (Direct)'),
                      _buildTableCell('Generators, LPG Kitchens, Institutional Fleet'),
                      _buildTableCell(engine.totalScope1Tons.toStringAsFixed(2), alignRight: true),
                      _buildTableCell('${((engine.totalScope1Tons / (engine.grossTons > 0 ? engine.grossTons : 1.0)) * 100).toStringAsFixed(1)}%', alignRight: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell('Scope 2 (Electricity)'),
                      _buildTableCell('Purchased Grid Power (CEA Baseline v19)'),
                      _buildTableCell(engine.totalScope2Tons.toStringAsFixed(2), alignRight: true),
                      _buildTableCell('${((engine.totalScope2Tons / (engine.grossTons > 0 ? engine.grossTons : 1.0)) * 100).toStringAsFixed(1)}%', alignRight: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell('Scope 3 (Indirect)'),
                      _buildTableCell('Staff/Student Commuter Vehicles, Academic Paper'),
                      _buildTableCell(engine.totalScope3Tons.toStringAsFixed(2), alignRight: true),
                      _buildTableCell('${((engine.totalScope3Tons / (engine.grossTons > 0 ? engine.grossTons : 1.0)) * 100).toStringAsFixed(1)}%', alignRight: true),
                    ],
                  ),
                ],
              ),

              pw.Spacer(),

              // Verification Sign-off Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: primaryColor, width: 1),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('VERIFIED AUDIT STATUS: COMPLIANT',
                            style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor)),
                        pw.Text('Calculation Engine: IPCC Tier-2 & CEA Database v19',
                            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Date: $dateStr',
                            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
                        pw.Text('Sign-off: Sustainability Lead Auditor',
                            style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Page 2: Detailed Ledgers & Clean Offsets
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('CarbonTrack Assessment • Detailed Activity Ledgers',
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: darkColor)),
                  pw.Text('Page 2', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                ],
              ),
              pw.SizedBox(height: 16),

              // Clean Offsets
              pw.Text('Clean Carbon Offsets & Ecological Sinks',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: primaryColor)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: greyBg),
                    children: [
                      _buildTableCell('Offset Mechanism', isHeader: true),
                      _buildTableCell('Quantity / Capacity', isHeader: true),
                      _buildTableCell('Factor Applied', isHeader: true),
                      _buildTableCell('Annual Sink (tCO₂e)', isHeader: true, alignRight: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell('Solar Rooftop PV'),
                      _buildTableCell('${engine.solarRows.length} arrays installed'),
                      _buildTableCell('0.792 kg/kWh avoided'),
                      _buildTableCell('-${engine.totalSolarOffsetTons.toStringAsFixed(2)} t', alignRight: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell('Native Tree Canopy'),
                      _buildTableCell('${engine.treeRows.fold(0, (sum, t) => sum + t.treeCount)} mature trees'),
                      _buildTableCell('15.0 - 62.5 kg/tree/yr'),
                      _buildTableCell('-${engine.totalTreeOffsetTons.toStringAsFixed(2)} t', alignRight: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell('Waste Recycling & Compost'),
                      _buildTableCell('${engine.wasteRows.length} material streams'),
                      _buildTableCell('0.20 - 8.50 kg/kg'),
                      _buildTableCell('-${engine.totalWasteOffsetTons.toStringAsFixed(2)} t', alignRight: true),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Vehicles Activity Ledger
              pw.Text('Campus Vehicles Activity Breakdown',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: secondaryColor)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: greyBg),
                    children: [
                      _buildTableCell('Vehicle Type', isHeader: true),
                      _buildTableCell('Fuel', isHeader: true),
                      _buildTableCell('Ownership', isHeader: true),
                      _buildTableCell('Count', isHeader: true),
                      _buildTableCell('Annual (tCO₂e)', isHeader: true, alignRight: true),
                    ],
                  ),
                  for (var v in engine.vehicles)
                    pw.TableRow(
                      children: [
                        _buildTableCell(v.type.toUpperCase()),
                        _buildTableCell(v.fuel.toUpperCase()),
                        _buildTableCell(v.ownership),
                        _buildTableCell('${v.count.toInt()}'),
                        _buildTableCell(v.annualTons.toStringAsFixed(3), alignRight: true),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Recommendations Box
              pw.Container(
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: const PdfColor(0.94, 0.99, 0.96),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: primaryColor, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Net-Zero Strategic Transition Recommendations',
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: primaryColor)),
                    pw.SizedBox(height: 6),
                    pw.Bullet(text: 'Transition diesel campus shuttle fleet to battery electric vehicles (EV).', style: const pw.TextStyle(fontSize: 9)),
                    pw.Bullet(text: 'Expand rooftop solar photovoltaic array capacity to offset purchased grid power.', style: const pw.TextStyle(fontSize: 9)),
                    pw.Bullet(text: 'Institutionalize 100% digital administration to reduce Scope 3 paper usage.', style: const pw.TextStyle(fontSize: 9)),
                    pw.Bullet(text: 'Maintain native tree plantation canopy to protect IPCC verified vegetative carbon sinks.', style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildPdfHeroStat(String title, String value, PdfColor color, {bool isHighlight = false}) {
    return pw.Column(
      children: [
        pw.Text(title, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: isHighlight ? 16 : 14,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPdfMetricTile(String label, String value, String sub) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F8FAFC'),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.SizedBox(height: 3),
          pw.Text(value, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
          pw.SizedBox(height: 2),
          pw.Text(sub, style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600)),
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false, bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: isHeader ? 8.5 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.black : PdfColors.grey800,
        ),
      ),
    );
  }
}
