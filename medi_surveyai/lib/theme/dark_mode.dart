import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1A1A1A),
    surface: Color(0xFF2D2D2D),
    primary: Color(0xFF00BFA5),
    secondary: Color(0xFF424242),
    onBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFFE0E0E0),
    outline: Color(0xFF424242),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFF00BFA5),
  ),
  scaffoldBackgroundColor: const Color(0xFF1A1A1A),
  cardColor: const Color(0xFF2D2D2D),
  dividerColor: const Color(0xFF424242),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    foregroundColor: Color(0xFFFFFFFF),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2D2D2D),
    labelStyle: const TextStyle(color: Color(0xFFE0E0E0)),
    hintStyle: const TextStyle(color: Color(0xFFE0E0E0)),
    prefixIconColor: const Color(0xFFE0E0E0),
    suffixIconColor: const Color(0xFFE0E0E0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF424242)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF424242)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF00BFA5)),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
    titleMedium: TextStyle(color: Color(0xFFFFFFFF)),
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
    bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
    labelLarge: TextStyle(color: Color(0xFFFFFFFF)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00BFA5),
      foregroundColor: const Color(0xFFFFFFFF),
      disabledBackgroundColor: const Color(0xFF424242),
      disabledForegroundColor: const Color(0xFFE0E0E0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF00BFA5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFFFFFFF),
  ),
);
