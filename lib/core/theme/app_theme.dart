import 'package:flutter/material.dart';

class AppTheme {
  // Common Colors
  static const Color whiteColor = Color(0xFFFFFFFF);   // White
  static const Color blackColor = Color(0xFF000000);   // Black
  static const Color greyTextColor = Color(0xFFB0B0B0); // Grey text

  // Dark Theme - Deep Navy & Neon
  static const Color darkBackground = Color(0xFF0A1929);
  static const Color darkCardBackground = Color(0xFF132F4C);
  static const Color darkPrimary = Color(0xFF00E5FF);  // Neon Cyan
  static const Color darkSecondary = Color(0xFFFF1E90); // Neon Pink
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFB0B0B0);

  // Light Theme - Cream Paper & Burgundy
  static const Color lightBackground = Color(0xFFF5F2E8);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF8B1E3F);   // Burgundy
  static const Color lightSecondary = Color(0xFF3E4A61); // Navy
  static const Color lightText = Color(0xFF121212);
  static const Color lightSecondaryText = Color(0xFF666666);

  // Dark Theme - Deep Navy & Neon
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkSecondary,
      surface: darkCardBackground,
      onPrimary: blackColor,
      onSecondary: whiteColor,
      onBackground: darkText,
      onSurface: darkText,
      tertiary: darkSecondaryText,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkText,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: darkCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: darkPrimary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: blackColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimary,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkCardBackground,
      disabledColor: darkCardBackground,
      selectedColor: darkPrimary,
      secondarySelectedColor: darkSecondary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelStyle: TextStyle(color: darkText),
      secondaryLabelStyle: TextStyle(color: whiteColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: darkSecondaryText),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: darkText),
      displayMedium: TextStyle(color: darkText),
      displaySmall: TextStyle(color: darkText),
      headlineMedium: TextStyle(color: darkText),
      headlineSmall: TextStyle(color: darkText),
      titleLarge: TextStyle(color: darkPrimary),
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
      bodySmall: TextStyle(color: darkSecondaryText),
    ),
  );

  // Light Theme - Cream Paper & Burgundy
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      secondary: lightSecondary,
      surface: lightCardBackground,
      onPrimary: whiteColor,
      onSecondary: whiteColor,
      onSurface: lightText,
      tertiary: lightSecondaryText,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightText,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: lightCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: lightPrimary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: whiteColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPrimary,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: lightCardBackground,
      disabledColor: lightCardBackground,
      selectedColor: lightPrimary,
      secondarySelectedColor: lightSecondary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelStyle: TextStyle(color: lightText),
      secondaryLabelStyle: TextStyle(color: whiteColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: lightSecondaryText),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: lightText),
      displayMedium: TextStyle(color: lightText),
      displaySmall: TextStyle(color: lightText),
      headlineMedium: TextStyle(color: lightText),
      headlineSmall: TextStyle(color: lightText),
      titleLarge: TextStyle(color: lightPrimary),
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
      bodySmall: TextStyle(color: lightSecondaryText),
    ),
  );
}