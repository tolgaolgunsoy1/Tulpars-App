import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Updated Tulpars Brand Colors
  static const Color primaryColor = Color(0xFF003875); // Primary Blue
  static const Color primaryLightColor = Color(0xFF0055A5); // Primary Light
  static const Color primaryDarkColor = Color(0xFF001F3F); // Primary Dark
  static const Color secondaryColor = Color(0xFFDC2626); // Emergency Red
  static const Color accentColor = Color(0xFFF59E0B); // Accent Orange
  static const Color successColor = Color(0xFF10B981); // Success Green
  static const Color backgroundColor = Color(0xFFF8FAFC); // Background
  static const Color surfaceColor = Color(0xFFFFFFFF); // Surface
  static const Color darkBackgroundColor = Color(0xFF1E293B); // Dark Background
  static const Color primaryTextColor = Color(0xFF0F172A); // Primary Text
  static const Color secondaryTextColor = Color(0xFF64748B); // Secondary Text
  static const Color disabledColor = Color(0xFFCBD5E1); // Disabled
  static const Color errorColor =
      Color(0xFFDC2626); // Error (same as secondary)

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryLightColor,
          onPrimary: Colors.white,
          secondary: secondaryColor,
          onSecondary: Colors.white,
          tertiary: accentColor,
          onTertiary: Colors.white,
          surface: surfaceColor,
          onSurface: primaryTextColor,
          surfaceContainerHighest: Colors.white,
          error: errorColor,
          onError: Colors.white,
          outline: secondaryTextColor,
          outlineVariant: disabledColor,), scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white,), iconTheme: const IconThemeData(color: Colors.white)), textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: GoogleFonts.montserrat(
            fontSize: 32, fontWeight: FontWeight.bold, color: primaryTextColor,), headlineMedium: GoogleFonts.montserrat(
            fontSize: 28, fontWeight: FontWeight.w600, color: primaryTextColor,), headlineSmall: GoogleFonts.montserrat(
            fontSize: 24, fontWeight: FontWeight.w600, color: primaryTextColor,), titleLarge: GoogleFonts.montserrat(
            fontSize: 22, fontWeight: FontWeight.w600, color: primaryTextColor,), titleMedium: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.w600, color: primaryTextColor,), titleSmall: GoogleFonts.montserrat(
            fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor,), bodyLarge: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: primaryTextColor,), bodyMedium: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: primaryTextColor,), bodySmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: secondaryTextColor,), labelLarge: GoogleFonts.roboto(
            fontSize: 14, fontWeight: FontWeight.w500, color: primaryTextColor,), labelMedium: GoogleFonts.roboto(
            fontSize: 12, fontWeight: FontWeight.w500, color: primaryTextColor,), labelSmall: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: secondaryTextColor,),
      ), elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), textStyle:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
      ), outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), textStyle:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
      ), textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
      ), inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)), focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryColor, width: 2)), errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorColor)), focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorColor, width: 2)), labelStyle: GoogleFonts.roboto(color: secondaryTextColor), hintStyle: GoogleFonts.roboto(color: disabledColor), contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16)), bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surfaceColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryTextColor,
          type: BottomNavigationBarType.fixed,
          elevation: 8,),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: accentColor,
          surface: Color(0xFF1E1E1E), error: errorColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white70,
          onError: Colors.white,), scaffoldBackgroundColor: const Color(0xFF121212), appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E), foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white,), iconTheme: const IconThemeData(color: Colors.white)), textTheme:
          GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineLarge: GoogleFonts.montserrat(
            fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white,), headlineMedium: GoogleFonts.montserrat(
            fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white,), headlineSmall: GoogleFonts.montserrat(
            fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white,), titleLarge: GoogleFonts.montserrat(
            fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white,), titleMedium: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,), titleSmall: GoogleFonts.montserrat(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,), bodyLarge: GoogleFonts.roboto(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white,), bodyMedium: GoogleFonts.roboto(
            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white,), bodySmall: GoogleFonts.roboto(
            fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70,), labelLarge: GoogleFonts.roboto(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white,), labelMedium: GoogleFonts.roboto(
            fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white,), labelSmall: GoogleFonts.roboto(
            fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white70,),
      ), elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), textStyle:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
      ), outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), textStyle:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
      ), textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
      ), inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade600)), enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade600)), focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryColor, width: 2)), errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorColor)), focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorColor, width: 2)), labelStyle: GoogleFonts.roboto(color: Colors.white70), hintStyle: GoogleFonts.roboto(color: Colors.white38), contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16)), bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E), selectedItemColor: primaryColor,
          unselectedItemColor: Colors.white38,
          type: BottomNavigationBarType.fixed,
          elevation: 8,),
    );
  }
}




