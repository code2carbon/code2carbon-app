import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Footer uses a dark surface — looks native (like a page footer, not a box)
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.eco_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: AppTypography.displaySmall.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  children: const [
                    TextSpan(text: 'Code'),
                    TextSpan(
                      text: '2Carbon',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"Small actions create a greener future."',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'An academic research portal focused on localized carbon indices and smart consumption models.',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.55),
              height: 1.5,
            ),
          ),
          const Divider(color: Colors.white24, height: 28),
          Text(
            'CONTACT & RESEARCH',
            style: AppTypography.sectionBadge.copyWith(
              color: const Color(0xFF6EE7B7),
            ),
          ),
          const SizedBox(height: 12),
          _ContactRow(
            icon: Icons.email_outlined,
            text: 'research@code2carbon.org',
          ),
          const SizedBox(height: 8),
          _ContactRow(
            icon: Icons.location_on_outlined,
            text: 'University Research Hub, Campus Green',
          ),
          const SizedBox(height: 8),
          _ContactRow(
            icon: Icons.phone_outlined,
            text: '+91 98765 43210',
          ),
          const Divider(color: Colors.white24, height: 28),
          Center(
            child: Text(
              '© 2026 Code2Carbon Platform.\nDeveloped for the Environmental Sciences Research Project.\nAll rights reserved.',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white60, size: 15),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
        ),
      ],
    );
  }
}
