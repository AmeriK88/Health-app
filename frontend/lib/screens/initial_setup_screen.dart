import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/styles.dart';
import '../widgets/buttons/custom_button.dart'; 

///  **Pantalla de Configuración Inicial**
/// - Permite al usuario ingresar datos básicos como **peso, altura y objetivo**.
/// - Los datos se envían al backend mediante saveData().
/// - Si los datos están incompletos, muestra un mensaje de error.
/// - Tras guardar correctamente, redirige a la pantalla principal (HomeScreen).

class InitialSetupScreen extends StatefulWidget {
  final String token;

  const InitialSetupScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  ///  **Controladores para capturar los datos ingresados**
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  bool isLoading = false; // Indica si los datos se están guardando
  String errorMessage = ''; // Almacena mensajes de error si ocurren

  ///  **Guardar los datos ingresados**
  /// - Verifica que todos los campos estén completos.
  /// - Envía los datos al backend usando ApiService().updateUserData().
  /// - Si la actualización es exitosa, muestra un mensaje y redirige a HomeScreen.
  Future<void> saveData() async {
    // 1️⃣ **Validación: Todos los campos son obligatorios**
    if (weightController.text.isEmpty ||
        heightController.text.isEmpty ||
        goalController.text.isEmpty) {
      setState(() {
        errorMessage = 'Todos los campos son obligatorios.';
      });

      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
      return;
    }

    // 2️⃣ **Mostrar indicador de carga**
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // 3️⃣ **Enviar datos al backend**
      await ApiService().updateUserData(
        token: widget.token,
        weight: double.tryParse(weightController.text),
        height: double.tryParse(heightController.text),
        goal: goalController.text,
      );

      //  **Datos guardados con éxito**
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados con éxito')),
      );

      //  **Redirigir al HomeScreen tras guardar**
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: widget.token,
      );
    } catch (e) {
      //  **Manejo de errores**
      setState(() {
        errorMessage = 'Error al guardar datos: $e';
      });

      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      // **Ocultar indicador de carga**
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// **Barra superior (AppBar)**
      appBar: AppBar(
        title: const Text('Configuración Inicial'),
        backgroundColor: AppStyles.primaryColor,
      ),

      /// **Cuerpo de la pantalla**
      body: SingleChildScrollView(
        padding: AppStyles.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///  **Mensaje de error (si hay)**
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  errorMessage,
                  style: AppStyles.errorTextStyle,
                ),
              ),

            /// **Título**
            const Text(
              'Completa los datos iniciales:',
              style: AppStyles.headerTextStyle,
            ),
            const SizedBox(height: 16),

            /// **Campo de entrada: Peso**
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            /// **Campo de entrada: Altura**
            TextField(
              controller: heightController,
              decoration: const InputDecoration(
                labelText: 'Altura (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            /// **Campo de entrada: Objetivo**
            TextField(
              controller: goalController,
              decoration: const InputDecoration(
                labelText: 'Objetivo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            /// **Botón de Guardar**
            CustomButton(
              text: 'Guardar', // Usa la propiedad `text` de CustomButton
              onPressed: saveData,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
