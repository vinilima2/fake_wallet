import 'package:flutter/material.dart';

class ThemeUtils {
  static final lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Colors.blue.shade900,
      onPrimary: Colors.blue.shade900,
      secondary: Colors.blue.shade700,
      onSecondary: const Color.fromARGB(255, 229, 248, 253),
      tertiary: Colors.amberAccent.shade400,
      onTertiary: Colors.yellow.shade200,
      error: Colors.redAccent.shade700,
      onError: Colors.redAccent.shade700,
      surface: Colors.white,
      onSurface: Colors.blue.shade900);

  static final darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.blue.shade800,
      onPrimary: Colors.blue.shade800,
      secondary: Colors.blue.shade600,
      onSecondary: Colors.grey.shade900,
      tertiary: Colors.amberAccent.shade700,
      onTertiary: const Color.fromARGB(255, 137, 137, 2),
      error: Colors.redAccent.shade700,
      onError: Colors.redAccent.shade700,
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

  static List<int> categoriesColor = [
    Colors.green.value,
    Colors.amber.value,
    Colors.red.value,
    Colors.orange.value,
    Colors.blue.value,
    Colors.pink.value,
    Colors.grey.value,
    Colors.cyan.value,
    Colors.indigo.value,
    Colors.purple.value,
    Colors.brown.value,
    Colors.yellow.value,
    Colors.lime.value,
    Colors.teal.value,
    Colors.lightGreen.value,
    Colors.pink.shade100.value
  ];
}
