import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF1A73E8);
  static const Color success = Color(0xFF34A853);
  static const Color error = Color(0xFFEA4335);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
