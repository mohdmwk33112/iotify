import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // Static color properties for direct access
  static const Color primaryColor = AppColors.darkAccentPurple;
  static const Color primaryColorLight = AppColors.lightAccentPurple;

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackgroundStart,
    primaryColor: AppColors.darkAccentPurple,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkAccentPurple,
      secondary: AppColors.darkAccentPurple,
      surface: AppColors.darkCardBackground,
      error: AppColors.darkDanger,
      onPrimary: AppColors.darkTextPrimary,
      onSecondary: AppColors.darkTextPrimary,
      onSurface: AppColors.darkTextPrimary,
      onError: AppColors.darkTextPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme.copyWith(
        bodyLarge: const TextStyle(color: AppColors.darkTextPrimary),
        bodyMedium: const TextStyle(color: AppColors.darkTextSecondaryStart),
        displayLarge: const TextStyle(color: AppColors.darkTextPrimary),
        displayMedium: const TextStyle(color: AppColors.darkTextPrimary),
        displaySmall: const TextStyle(color: AppColors.darkTextPrimary),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackgroundStart,
      elevation: 0,
      foregroundColor: AppColors.darkTextPrimary,
    ),
    cardTheme: const CardTheme(
      color: AppColors.darkCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDeviceOffBackground,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightAppBackground,
    primaryColor: AppColors.lightAccentPurple,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightAccentPurple,
      secondary: AppColors.lightAccentPurple,
      surface: AppColors.lightCardBackground,
      error: AppColors.lightDanger,
      onPrimary: AppColors.lightTextPrimary,
      onSecondary: AppColors.lightTextPrimary,
      onSurface: AppColors.lightTextPrimary,
      onError: AppColors.lightTextPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme.copyWith(
        bodyLarge: const TextStyle(color: AppColors.lightTextPrimary),
        bodyMedium: const TextStyle(color: AppColors.lightTextSecondary),
        displayLarge: const TextStyle(color: AppColors.lightTextPrimary),
        displayMedium: const TextStyle(color: AppColors.lightTextPrimary),
        displaySmall: const TextStyle(color: AppColors.lightTextPrimary),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightNavBarBackground,
      elevation: 0,
      foregroundColor: AppColors.lightTextPrimary,
    ),
    cardTheme: const CardTheme(
      color: AppColors.lightCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
    ),
  );
} 