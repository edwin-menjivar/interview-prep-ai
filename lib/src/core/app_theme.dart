import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1338BE),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF1338BE),
      secondary: const Color(0xFFF97316),
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FB),
    textTheme: GoogleFonts.spaceGroteskTextTheme(),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1338BE), width: 1.5),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 1.5,
    ),
  );

  const AppTheme._();
}
