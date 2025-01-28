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
    decoration: TextDecoration.underline,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle chatMessageTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );

  // Paddings y Margins
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);

  // Bordes y Sombras
  static RoundedRectangleBorder cardBorderStyle = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  );

  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 10,
    offset: Offset(0, 5),
  );

  // Botones
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static ButtonStyle disabledButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  // Iconos
  static const double iconSize = 24.0;
  static const double avatarRadius = 50.0; // Tamaño del avatar
  static const Color iconColor = Colors.grey;

  // Input Styles
  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
