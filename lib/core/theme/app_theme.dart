import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Galala University — Editorial Light Theme ──────────────────────────────
//
// A crisp, clean, and highly readable light theme inspired by editorial
// design. Uses GU Navy for text and contrast, GU Green for actions, and
// GU Gold for highlights. Backgrounds are bright and spacious.
// ──────────────────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // ── Brand Identity ────────────────────────────────────────────────────────
  static const Color guNavy = Color(0xFF12284C);
  static const Color guGreen = Color(0xFF31B44B);
  static const Color guGold = Color(0xFFFCB900);

  // ── Canvas & Surfaces ─────────────────────────────────────────────────────
  static const Color canvas = Color(0xFFF8F9FA); // Main app background
  static const Color surface = Color(0xFFFFFFFF); // Cards and containers
  static const Color surfaceSubtle =
      Color(0xFFF1F3F5); // Inputs, subtle backgrounds
  static const Color surfaceElevated = Color(0xFFFFFFFF); // Modals, popups

  // ── Text Hierarchy ────────────────────────────────────────────────────────
  static const Color textPrimary =
      Color(0xFF12284C); // Headings & primary body (using GU Navy for elegance)
  static const Color textSecondary =
      Color(0xFF495873); // Subtitles, secondary text
  static const Color textMuted = Color(0xFF8A98AF); // Hints, inactive text
  static const Color textGhost = Color(0xFFADB5C2); // Very faint text
  static const Color textOnDark =
      Color(0xFFFFFFFF); // Text on green or navy backgrounds

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFE03131);
  static const Color warning = Color(0xFFF08C00);
  static const Color success = Color(0xFF2F9E44);
  static const Color info = Color(0xFF1971C2);

  // ── Borders ───────────────────────────────────────────────────────────────
  static const Color borderSubtle = Color(0xFFE9ECEF);
  static const Color borderMedium = Color(0xFFDEE2E6);
  static const Color borderDark = Color(0xFFCED4DA);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF3DB166), Color(0xFF31B44B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// ─── Theme ────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.guGreen,
        secondary: AppColors.guGold,
        surface: AppColors.canvas,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.guNavy,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme:
          GoogleFonts.dmSansTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -1.0,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
          height: 1.15,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        headlineMedium: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.2,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.55,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnDark,
          letterSpacing: 0.3,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.guGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.guNavy,
          side: const BorderSide(color: AppColors.borderMedium, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSubtle,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide.none, // No border for cleaner look in light theme
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.guNavy, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
        ),
        labelStyle: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        prefixIconColor: AppColors.textMuted,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.canvas,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle:
            SystemUiOverlayStyle.dark, // Dark icons for light theme
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.guNavy),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.guGreen,
        unselectedItemColor: AppColors.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
