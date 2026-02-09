import 'package:flutter/material.dart';

class AppColors {
  static Color dark = Color(0xFF000000);
  static Color white = Color(0xFFFFFFFF);
  static Color whitegrey = const Color(0xFFf4f4f4);

  static Color blue = Color(0xFF0094ff);
  static Color green = const Color(0xFF0B5E0E);
  static Color grey = const Color(0xFF3a3a3c);
  static Color greydark = const Color(0xFF2c2c2e);
  static Color darkgrey = const Color(0xFF191919);
  static Color greylight = const Color(0xFF59595D);
  static Color red = const Color(0xFFC50000);
}

class ContactDetailsTheme {
  static const List<Color> backgroundColors = [
    Color(0xFF524E66),
    Color(0xFF544D80),
    Color(0xFF584E77),
    Color(0xFF221E38),
  ];

  static const List<double> backgroundStops = [0.0, 0.40, 0.70, 1.0];

  static const Color glassColor = Color(0xFF0A0814);

  static const Color cardTint = Color(0xFF3E3653);

  static const Color actionTint = Color(0xFF2B2540);

  static const TextStyle title = TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle cardTitle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle cardValue = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle label = TextStyle(color: Colors.white70, fontSize: 15);

  static const TextStyle muted = TextStyle(color: Colors.white70, fontSize: 16);
}
