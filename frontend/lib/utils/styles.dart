import 'package:flutter/material.dart';

class AppStyles {
  // Colores principales
  static const Color primaryColor = Colors.teal;
  static const Color accentColor = Colors.tealAccent;
  static const Color secondaryColor = Colors.blueAccent;
  static const Color secondaryAccentColor = Colors.lightBlue;

  // Gradientes
  static const BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static const BoxDecoration loginGradientBackground = BoxDecoration(
    gradient: LinearGradient(
      colors: [secondaryColor, secondaryAccentColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  // TextStyles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle loginHeaderTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  );

  static const TextStyle errorTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 18,
  );

  static const TextStyle linkTextStyle = TextStyle(
    color: secondaryColor,
    fontSize: 14,
  );

  // Paddings y Margins
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);

  // BorderStyles
  static RoundedRectangleBorder cardBorderStyle = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  );

  // Estilo para botones principales
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
