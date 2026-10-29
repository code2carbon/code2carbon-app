import 'package:flutter/material.dart';

/// Code2Carbon Brand Color Palette — Professional 2025 Design System
class AppColors {
  // Primary Palette (Emerald Green)
  static const Color primary = Color(0xFF10B981);
  static const Color primaryHover = Color(0xFF059669);
  static const Color primaryDark = Color(0xFF064E3B);
  static const Color primaryForest = Color(0xFF065F46);
  static const Color primaryLight = Color(0xFFF0FDF4);
  static const Color primaryMint = Color(0xFFECFDF5);
  static const Color primaryAccent = Color(0xFF34D399);

  // Secondary Palette (Sky / Royal Blue)
  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryHover = Color(0xFF2563EB);
  static const Color secondaryDark = Color(0xFF1D4ED8);
  static const Color secondaryLight = Color(0xFFEFF6FF);

  // AI & EcoBot Palette (Indigo / Violet Gradient)
  static const Color aiIndigo = Color(0xFF6366F1);
  static const Color aiViolet = Color(0xFF8B5CF6);
  static const Color aiLight = Color(0xFFF5F3FF);

  // Dark & Neutral Backgrounds
  static const Color dark = Color(0xFF0F172A);
  static const Color darkSlate = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color surfaceSubtle = Color(0xFFF1F5F9);
  static const Color cardBg = Colors.white;
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderDivider = Color(0xFFF1F5F9);

  // Scope & Status Accents
  static const Color scope1 = Color(0xFFEA580C); // Direct Combustion Orange
  static const Color scope1Light = Color(0xFFFFF7ED);
  static const Color scope2 = Color(0xFF2563EB); // Purchased Energy Blue
  static const Color scope2Light = Color(0xFFEFF6FF);
  static const Color scope3 = Color(0xFF7C3AED); // Value Chain Purple
  static const Color scope3Light = Color(0xFFF5F3FF);
  static const Color offset = Color(0xFF10B981); // Clean Offset Emerald
  static const Color offsetLight = Color(0xFFECFDF5);

  // Indicators
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Curated Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGreenGradient = LinearGradient(
    colors: [Color(0xFF064E3B), Color(0xFF065F46), Color(0xFF047857)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGradient = LinearGradient(
    colors: [aiIndigo, aiViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0xFFF0FDF4), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

