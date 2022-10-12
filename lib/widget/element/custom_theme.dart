import 'package:flutter/material.dart';

final customTheme = ThemeData(
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
  toggleButtonsTheme: ToggleButtonsThemeData(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    selectedBorderColor: Colors.brown[700],
    selectedColor: Colors.white,
    fillColor: Colors.brown[300],
    color: Colors.brown[300],
  ),
  fontFamily: 'Georgia',
);