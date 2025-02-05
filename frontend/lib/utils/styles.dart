import 'package:flutter/material.dart';

class AppStyles {
  // Paleta de colores
  static const MaterialColor primarySwatch = Colors.teal;
  static const Color primaryColor = Color(0xFF008080);
  static const Color secondaryColor = Color(0xFF1565C0);
  static const Color accentColor = Color(0xFF00BFA5);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF43A047);

  // Gradientes
  static BoxDecoration gradientBackground = const BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static BoxDecoration loginGradientBackground = const BoxDecoration(
    gradient: LinearGradient(
      colors: [secondaryColor, primaryColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  // TextStyles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: primaryColor,
  );

  static const TextStyle subHeaderTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: secondaryColor,
  );

  static const TextStyle errorTextStyle = TextStyle(
    color: errorColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle linkTextStyle = TextStyle(
    color: secondaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle chatMessageTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  // ✅ **Correcciones Agregadas**
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 10);

  static const TextStyle loginHeaderTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  // Espaciado responsivo
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  // Bordes y sombras
  static RoundedRectangleBorder cardBorderStyle = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  // Botones
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
  );

  static ButtonStyle disabledButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[400],
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // Iconos
  static const double iconSize = 28.0;
  static const double avatarRadius = 55.0;
  static const Color iconColor = Colors.grey;

  // Estilo para inputs
  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
    );
  }
}
