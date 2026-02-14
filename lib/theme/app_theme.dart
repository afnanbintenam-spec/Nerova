import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const ink = Color(0xFF0B1A2E);
  static const navy = Color(0xFF10253E);
  static const mist = Color(0xFFF1F5FB);
  static const sky = Color(0xFFBFD7FF);
  static const electric = Color(0xFF5B6DFF);
  static const mint = Color(0xFF4BC6B9);
  static const amber = Color(0xFFF9B233);
  static const rose = Color(0xFFF07167);
  static const line = Color(0xFFE2E8F0);
}

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.electric,
      secondary: AppColors.mint,
      surface: Colors.white,
      onSurface: AppColors.ink,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: AppColors.rose,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.mist,
    textTheme: GoogleFonts.dmSansTextTheme().apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.mist,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    ),
  );
}
