import 'package:flutter/material.dart';

final customTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.dark,
  primaryColor: Colors.brown[300],
  indicatorColor: Colors.white,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.brown[300],
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.brown[300]
  ),

  // Define the default font family.
  fontFamily: 'Georgia',
);