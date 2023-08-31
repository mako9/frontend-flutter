import 'package:flutter/material.dart';

final customTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.brown[200],
  indicatorColor: Colors.white,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.brown[200],
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.brown[200]
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    selectedBorderColor: Colors.brown[700],
    selectedColor: Colors.white,
    fillColor: Colors.brown[200],
    color: Colors.brown[200],
  ),
  fontFamily: 'Georgia',
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateColor.resolveWith((states) => Colors.brown[300]!),
  ),
);