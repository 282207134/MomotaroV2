import 'package:flutter/material.dart';

abstract final class Palette {
  static const ink = Color(0xFF2D3142);
  static const purple = Color(0xFF7265E3);
  static const lavender = Color(0xFF8E80F8);
  static const lilac = Color(0xFFB08AF9);
  static const mint = Color(0xFF7FE3EB);
  static const blue = Color(0xFF2688FF);
  static const slate = Color(0xFF4C5980);
  static const muted = Color(0xFF9C9EB9);
  static const cloud = Color(0xFFF5F5FA);
  static const pale = Color(0xFFE8E2FC);
  static const coral = Color(0xFFFF9797);
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Rubik',
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(seedColor: Palette.purple).copyWith(
    primary: Palette.purple,
    secondary: Palette.mint,
    surface: Colors.white,
  ),
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'Rubik',
    bodyColor: Palette.ink,
    displayColor: Palette.ink,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Palette.ink,
    elevation: 0,
    centerTitle: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Palette.cloud,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.all(18),
    hintStyle: const TextStyle(color: Palette.muted, fontSize: 14),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(54),
      backgroundColor: Palette.purple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Palette.purple),
  ),
  dividerTheme: const DividerThemeData(color: Palette.cloud, space: 28),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Palette.ink,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
);
