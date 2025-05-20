import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF5F5F5),
    primary: Color(0xFF00BFA5),
    secondary: Color(0xFFE0E0E0),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF424242),
    outline: Color(0xFFE0E0E0),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    tertiary: Color(0xFF00BFA5),
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  cardColor: const Color(0xFFF5F5F5),
  dividerColor: const Color(0xFFE0E0E0),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF),
    foregroundColor: Color(0xFF000000),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF000000)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF5F5F5),
    labelStyle: const TextStyle(color: Color(0xFF424242)),
    hintStyle: const TextStyle(color: Color(0xFF424242)),
    prefixIconColor: const Color(0xFF424242),
    suffixIconColor: const Color(0xFF424242),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF00BFA5)),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFF000000)),
    titleMedium: TextStyle(color: Color(0xFF000000)),
    bodyLarge: TextStyle(color: Color(0xFF424242)),
    bodyMedium: TextStyle(color: Color(0xFF424242)),
    labelLarge: TextStyle(color: Color(0xFF000000)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00BFA5),
      foregroundColor: const Color(0xFFFFFFFF),
      disabledBackgroundColor: const Color(0xFFE0E0E0),
      disabledForegroundColor: const Color(0xFF424242),
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
    color: Color(0xFF000000),
  ),
);
