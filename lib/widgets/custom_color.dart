import 'package:flutter/material.dart';

class CustomColors {
  // Primary Colors
  static const Color primaryOrange = Color(0xFFFF6A00);
  static const Color softBeige = Color(0xFFF4ECDD);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGray = Color(0xFF111111);
  static const Color mediumGray = Color(0xFF474747);
  static const Color lightGray = Color(0xFFF1F1F1);
  static const Color borderGray = Color(0xFFE1E1E1);
  static const Color textGray = Color(0xFF97989D);
  static const Color chipTextGray = Color(0xFF232323);
  static const Color hintGray = Color(0xFFB7B7B7);
  static const Color cardGray = Color(0xFF464646);

  // Background Colors
  static const Color iconBg = Color(0xFFF3E9DB);

  // Transparency variations
  static Color blackOverlay(double opacity) =>
      Colors.black.withOpacity(opacity);
}
