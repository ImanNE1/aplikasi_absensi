import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0D47A1); // Biru tua
  static const Color secondaryColor = Color(0xFF1976D2); // Biru medium
  static const Color accentColor = Color(0xFF42A5F5); // Biru muda
  static const Color backgroundColor =
      Color(0xFFF5F5F5); // Abu-abu muda untuk background
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F); // Merah untuk error

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: backgroundColor,
      surface: cardColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xFF212121), // Teks gelap di background terang
      onSurface: Color(0xFF212121), // Teks gelap di surface terang
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge:
          GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      labelLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: GoogleFonts.inter(color: Colors.grey[700]),
      hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    ),
  );

  // (Opsional) Definisikan darkTheme jika diperlukan
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      // Sesuaikan warna dan properti untuk tema gelap
      );
}
