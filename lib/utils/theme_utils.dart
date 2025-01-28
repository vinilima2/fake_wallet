import 'package:flutter/material.dart';

class ThemeUtils {
  static final lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Colors.blue.shade900,
      onPrimary: Colors.blue.shade900,
      secondary: Colors.blue.shade700,
      onSecondary: Colors.lightBlue.shade100,
      tertiary: Colors.amberAccent.shade400,
      onTertiary: Colors.yellow.shade200,
      error: Colors.blue.shade900,
      onError: Colors.blue.shade900,
      surface: Colors.white,
      onSurface: Colors.blue.shade900);

  static final darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.blue.shade900,
      onPrimary: Colors.blue.shade900,
      secondary: Colors.blue.shade300,
      onSecondary: Colors.blueGrey.shade900,
      tertiary: Colors.amberAccent.shade700,
      onTertiary: const Color.fromARGB(255, 137, 137, 2),
      error: Colors.blue.shade900,
      onError: Colors.blue.shade900,
      surface: Colors.black,
      onSurface: Colors.blue.shade800);

  static const List<MaterialColor> chartColors = [
    Colors.green,
    Colors.amber,
    Colors.red,
    Colors.orange,
    Colors.blue,
    Colors.pink,
    Colors.grey,
    Colors.cyan,
    Colors.indigo,
    Colors.purple,
    Colors.brown
  ];
}
