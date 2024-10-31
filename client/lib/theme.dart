import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

final themeData = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  textTheme: TextTheme(
      headlineMedium: GoogleFonts.emilysCandy(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        color: colorScheme.primary,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorScheme.secondary,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSecondaryContainer,
      )),
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);
