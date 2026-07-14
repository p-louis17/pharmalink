import 'package:flutter/material.dart';

// Single source of truth for colors, fonts, and shapes.
// Nobody should hardcode a Color(0xFF...) inside a feature screen —
// pull it from here so the app stays visually consistent across features.
class AppTheme {
  static const Color primary = Color(0xFF1D5FAD);   // buttons, active nav icon
  static const Color accent = Color(0xFF0F9D58);    // "in stock" green
  static const Color warning = Color(0xFF9C27B0);   // "limited stock" purple
  static const Color danger = Color(0xFFD32F2F);    // "unavailable" red

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
