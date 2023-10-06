import 'package:flutter/material.dart';

class AppTheme {
  static const ColorScheme colorScheme = ColorScheme.dark(
    primary: Colors.red,
    onPrimary: Colors.white,
  );

  static final ThemeData themeData = ThemeData.dark().copyWith(
    colorScheme: colorScheme,
    /*sliderTheme: SliderThemeData(

    ),*/
  );
}