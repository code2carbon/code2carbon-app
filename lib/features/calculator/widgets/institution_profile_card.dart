import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../services/calculator_engine.dart';

class InstitutionProfileCard extends StatefulWidget {
  const InstitutionProfileCard({super.key});

  @override
  State<InstitutionProfileCard> createState() => _InstitutionProfileCardState();
}

class _InstitutionProfileCardState extends State<InstitutionProfileCard> {
  final _engine = CalculatorEngine();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _campusAreaController;
  late TextEditingController _builtUpAreaController;
  late TextEditingController _populationController;
  late TextEditingController _studentsController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  @override
  void initState() {
    super.initState();
    final p = _engine.profile;
    _nameController = TextEditingController(text: p.name);
    _addressController = TextEditingController(text: p.address);
    _contactController = TextEditingController(text: p.contact);
    _emailController = TextEditingController(text: p.email);
    _campusAreaController =
        TextEditingController(text: p.campusAreaAcres.toString());
    _builtUpAreaController =
        TextEditingController(text: p.builtUpAreaSqm.toString());
    _populationController =
        TextEditingController(text: p.totalPopulation.toString());
    _studentsController =
        TextEditingController(text: p.studentsCount.toString());
    _latController = TextEditingController(text: p.latitude.toString());
    _lngController = TextEditingController(text: p.longitude.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _campusAreaController.dispose();
    _builtUpAreaController.dispose();
    _populationController.dispose();
    _studentsController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updated = _engine.profile.copyWith(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      contact: _contactController.text.trim(),
      email: _emailController.text.trim(),
      campusAreaAcres: double.tryParse(_campusAreaController.text) ?? 45.0,
      builtUpAreaSqm: double.tryParse(_builtUpAreaController.text) ?? 28900.0,
      totalPopulation: int.tryParse(_populationController.text) ?? 3500,
      studentsCount: int.tryParse(_studentsController.text) ?? 3000,
      latitude: double.tryParse(_latController.text) ?? 18.5204,
      longitude: double.tryParse(_lngController.text) ?? 73.8567,
    );
    _engine.updateProfile(updated);
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _engine.profile.logoPath = picked.path;
        _engine.profile.logoFileName = picked.name;
      });
      _engine.refresh();
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _engine.profile.collegePhotoPath = picked.path;
        _engine.profile.photoFileName = picked.name;
      });
      _engine.refresh();
    }
  }

  Future<void> _pickLayoutPlan() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result.isNotEmpty) {
      final file = result.first;
      setState(() {
        _engine.profile.layoutPlanPath = file.path;
        _engine.profile.layoutFileName = file.name;
      });
      _engine.refresh();
    }
  }

  static const _fieldStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
  );

  InputDecoration _inputDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
      prefixIcon: Icon(icon, size: 17, color: AppColors.primary.withValues(alpha: 0.8)),
      prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Page Header — sits directly on clean surface, NO outer box
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.apartment_rounded,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INSTITUTIONAL PROFILE',
                    style: AppTypography.sectionBadge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Campus & Spatial Baseline',
                    style: AppTypography.displaySmall.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Required for intensity normalization and audit reporting',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 24),

        // ── Section: Identity & Contact ──────────────────────────
        const _SectionLabel(title: 'Identity & Contact', icon: Icons.badge_outlined),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          style: _fieldStyle,
          decoration: _inputDeco('Institution Name', Icons.school_outlined),
          onChanged: (_) => _saveProfile(),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _addressController,
          style: _fieldStyle,
          decoration: _inputDeco('Campus Address', Icons.location_on_outlined),
          onChanged: (_) => _saveProfile(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _contactController,
                style: _fieldStyle,
                decoration: _inputDeco('Contact (+91)', Icons.phone_outlined),
                onChanged: (_) => _saveProfile(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _emailController,
                style: _fieldStyle,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDeco('Official Email', Icons.email_outlined),
                onChanged: (_) => _saveProfile(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // ── Section: Demographics & Campus Area ──────────────────
        const _SectionLabel(title: 'Demographics & Campus Area', icon: Icons.groups_outlined),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _campusAreaController,
                style: _fieldStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDeco('Campus Area (acres)', Icons.landscape_outlined),
                onChanged: (_) => _saveProfile(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _builtUpAreaController,
                style: _fieldStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDeco('Built-up Area (m²)', Icons.square_foot_outlined),
                onChanged: (_) => _saveProfile(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _populationController,
                style: _fieldStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDeco('Total Population', Icons.groups_outlined),
                onChanged: (_) => _saveProfile(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _studentsController,
                style: _fieldStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDeco('Students Count', Icons.person_outline),
                onChanged: (_) => _saveProfile(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // ── Section: Geographic Coordinates ──────────────────────
        const _SectionLabel(title: 'Geographic Coordinates', icon: Icons.explore_outlined),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _latController,
                style: _fieldStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDeco('Latitude', Icons.explore_outlined),
                onChanged: (_) => _saveProfile(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _lngController,
                style: _fieldStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDeco('Longitude', Icons.explore_outlined),
                onChanged: (_) => _saveProfile(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // ── Section: Institutional Attachments ───────────────────
        const _SectionLabel(title: 'Institutional Attachments', icon: Icons.attach_file_rounded),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _FileUploadTile(
                label: 'College Logo',
                fileName: _engine.profile.logoFileName,
                icon: Icons.image_outlined,
                onPick: _pickLogo,
                onRemove: () {
                  setState(() {
                    _engine.profile.logoPath = null;
                    _engine.profile.logoFileName = null;
                  });
                  _engine.refresh();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FileUploadTile(
                label: 'Campus Photo',
                fileName: _engine.profile.photoFileName,
                icon: Icons.camera_alt_outlined,
                onPick: _pickPhoto,
                onRemove: () {
                  setState(() {
                    _engine.profile.collegePhotoPath = null;
                    _engine.profile.photoFileName = null;
                  });
                  _engine.refresh();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FileUploadTile(
                label: 'Layout Plan',
                fileName: _engine.profile.layoutFileName,
                icon: Icons.map_outlined,
                onPick: _pickLayoutPlan,
                onRemove: () {
                  setState(() {
                    _engine.profile.layoutPlanPath = null;
                    _engine.profile.layoutFileName = null;
                  });
                  _engine.refresh();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Inline section label — replaces outer card boxes
class _SectionLabel extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionLabel({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.borderDivider,
          ),
        ),
      ],
    );
  }
}

class _FileUploadTile extends StatelessWidget {
  final String label;
  final String? fileName;
  final IconData icon;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const _FileUploadTile({
    required this.label,
    required this.fileName,
    required this.icon,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null && fileName!.isNotEmpty;

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hasFile ? AppColors.primaryLight : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasFile
                ? AppColors.primary.withValues(alpha: 0.35)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: hasFile ? AppColors.primaryDark : AppColors.textMuted,
                ),
                if (hasFile) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onRemove,
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: hasFile ? AppColors.primaryDark : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              hasFile ? fileName! : 'Upload',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: hasFile ? AppColors.primary : AppColors.secondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
