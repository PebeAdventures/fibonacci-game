import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application-wide theme configuration.
/// Uses a dark purple/indigo palette fitting for a math/game aesthetic.
class AppTheme {
  AppTheme._();

  // =====================================================================
  // COLOR PALETTE
  // =====================================================================
  static const Color primary = Color(0xFF6C63FF);       // Purple accent
  static const Color primaryDark = Color(0xFF4B44CC);   // Darker purple
  static const Color secondary = Color(0xFF03DAC6);     // Teal accent for correct answers
  static const Color error = Color(0xFFCF6679);         // Red for errors/wrong answers
  static const Color background = Color(0xFF121212);    // Dark background
  static const Color surface = Color(0xFF1E1E2E);       // Card/surface color
  static const Color surfaceVariant = Color(0xFF2A2A3E); // Slightly lighter surface
  static const Color onBackground = Color(0xFFE8E8F0);  // Text on dark background
  static const Color onSurface = Color(0xFFCACADB);     // Secondary text
  static const Color correctGreen = Color(0xFF4CAF50);  // Correct answer highlight
  static const Color wrongRed = Color(0xFFE53935);      // Wrong answer highlight
  static const Color goldRank1 = Color(0xFFFFD700);     // Gold for rank 1
  static const Color silverRank2 = Color(0xFFC0C0C0);   // Silver for rank 2
  static const Color bronzeRank3 = Color(0xFFCD7F32);   // Bronze for rank 3

  // =====================================================================
  // THEME DATA
  // =====================================================================
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        error: error,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: onBackground,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: onBackground,
          ),
          displayMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: onBackground,
          ),
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: onBackground,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: onBackground,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onBackground,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: onBackground,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: onSurface,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onBackground,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: surface,
        selectedIconTheme: IconThemeData(color: primary),
        unselectedIconTheme: IconThemeData(color: onSurface),
        selectedLabelTextStyle: TextStyle(color: primary, fontWeight: FontWeight.w600),
        unselectedLabelTextStyle: TextStyle(color: onSurface),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2A2A3E), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A5A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A5A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: const TextStyle(color: onSurface),
        hintStyle: TextStyle(color: onSurface.withOpacity(0.5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
