import 'package:flutter/material.dart';
import '../utils/styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final ButtonStyle? style; // Hacemos 'style' opcional

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.style, // Quitamos el valor predeterminado aquí
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style ?? AppStyles.primaryButtonStyle, // Valor por defecto si 'style' es null
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(text, style: AppStyles.buttonTextStyle),
    );
  }
}
