import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../app/theme/app_colors.dart';
import '../../calculator/services/calculator_engine.dart';
import '../services/pdf_report_generator.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = CalculatorEngine();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Accredited Carbon Report',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.dark,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              final pdfBytes =
                  await PdfReportGenerator.generateAccreditedReport(engine);
              await Printing.sharePdf(
                bytes: pdfBytes,
                filename:
                    'CarbonTrack_${engine.profile.name.replaceAll(' ', '_')}_Assessment.pdf',
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => PdfReportGenerator.generateAccreditedReport(engine),
        initialPageFormat: PdfPageFormat.a4,
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        pdfFileName:
            'CarbonTrack_${engine.profile.name.replaceAll(' ', '_')}_Audit.pdf',
      ),
    );
  }
}
