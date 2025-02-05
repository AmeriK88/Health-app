import 'package:flutter/material.dart';

///  **ConfigurationScreen** - Pantalla de configuración inicial.
/// - Se usa para configurar los ajustes antes de comenzar.
/// - Actualmente solo muestra un mensaje, pero puede expandirse en el futuro.
class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Inicial'),
      ),
      body: const Center(
        child: Text('Pantalla de Configuración Inicial'),
      ),
    );
  }
}
