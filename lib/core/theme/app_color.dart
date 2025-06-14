import 'package:flutter/material.dart';

// App Color Palette
class AppColors {
  // Primary Colors - Professional Blue Gradient
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueLight = Color(0xFF3B82F6);

  // Secondary Colors - Warm Accent
  static const Color secondaryOrange = Color(0xFFEA580C);
  static const Color secondaryOrangeLight = Color(0xFFF97316);
  static const Color secondaryAmber = Color(0xFFF59E0B);

  // Success & Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors - Light Theme
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color dividerLight = Color(0xFFF3F4F6);

  // Neutral Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textTertiaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF475569);
  static const Color dividerDark = Color(0xFF334155);

  // Role-specific Colors
  static const Color managerAccent = Color(0xFF7C3AED);
  static const Color teacherAccent = Color(0xFF059669);
  static const Color studentAccent = Color(0xFF0EA5E9);

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = LinearGradient(
    colors: [secondaryOrange, secondaryAmber],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
