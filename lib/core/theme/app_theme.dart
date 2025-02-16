import 'package:flutter/material.dart';

class AppTheme {
  // Common Colors
  static const Color primaryPink = Color(0xFFED63DB);  // Pink
  static const Color whiteColor = Color(0xFFFFFFFF);   // White
  static const Color blackColor = Color(0xFF000000);   // Black
  static const Color lightGreyColor = Color(0xFFD3D3D3); // Light Grey (Like the image)
  static const Color darkGreyColor = Color(0xFF2A2A2A);  // Dark Grey version

  // Light Grey Theme
  static ThemeData lightGreyTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: blackColor,
      secondary: blackColor,
      background: lightGreyColor,
      surface: lightGreyColor,
      onPrimary: whiteColor,
      onSecondary: whiteColor,
      onBackground: blackColor,
      onSurface: blackColor,
    ),
    scaffoldBackgroundColor: lightGreyColor,
    appBarTheme: AppBarTheme(
      backgroundColor: lightGreyColor,
      foregroundColor: blackColor,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: whiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryPink,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPink,
        foregroundColor: whiteColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: blackColor),
      displayMedium: TextStyle(color: blackColor),
      displaySmall: TextStyle(color: blackColor),
      headlineMedium: TextStyle(color: blackColor),
      headlineSmall: TextStyle(color: blackColor),
      titleLarge: TextStyle(color: blackColor),
      bodyLarge: TextStyle(color: blackColor),
      bodyMedium: TextStyle(color: blackColor),
    ),
  );

  // Light purple Theme
  static ThemeData lightPurpleTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryPink,
      secondary: darkGreyColor,
      background: whiteColor,
      surface: whiteColor,
      onPrimary: whiteColor,
      onSecondary: whiteColor,
      onBackground: darkGreyColor,
      onSurface: blackColor,
    ),
    scaffoldBackgroundColor: lightGreyColor,
    appBarTheme: AppBarTheme(
      backgroundColor: lightGreyColor,
      foregroundColor: blackColor,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: whiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryPink,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPink,
        foregroundColor: whiteColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: blackColor),
      displayMedium: TextStyle(color: blackColor),
      displaySmall: TextStyle(color: blackColor),
      headlineMedium: TextStyle(color: blackColor),
      headlineSmall: TextStyle(color: blackColor),
      titleLarge: TextStyle(color: blackColor),
      bodyLarge: TextStyle(color: blackColor),
      bodyMedium: TextStyle(color: blackColor),
    ),
  );

  // Dark Grey Theme
  static ThemeData darkGreyTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryPink,
      secondary: whiteColor,
      background: darkGreyColor,
      surface: darkGreyColor,
      onPrimary: blackColor,
      onSecondary: blackColor,
      onBackground: lightGreyColor,
      onSurface: lightGreyColor,
    ),
    scaffoldBackgroundColor: darkGreyColor,
    appBarTheme: AppBarTheme(
      backgroundColor: darkGreyColor,
      foregroundColor: lightGreyColor,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: darkGreyColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryPink,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPink,
        foregroundColor: darkGreyColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: lightGreyColor),
      displayMedium: TextStyle(color: lightGreyColor),
      displaySmall: TextStyle(color: lightGreyColor),
      headlineMedium: TextStyle(color: lightGreyColor),
      headlineSmall: TextStyle(color: lightGreyColor),
      titleLarge: TextStyle(color: lightGreyColor),
      bodyLarge: TextStyle(color: lightGreyColor),
      bodyMedium: TextStyle(color: lightGreyColor),
    ),
  );

}