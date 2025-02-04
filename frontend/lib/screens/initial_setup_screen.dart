import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/styles.dart';
import '../widgets/buttons/custom_button.dart'; // Asegúrate de importar CustomButton aquí

class InitialSetupScreen extends StatefulWidget {
  final String token;

  const InitialSetupScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> saveData() async {
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

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await ApiService().updateUserData(
        token: widget.token,
        weight: double.tryParse(weightController.text),
        height: double.tryParse(heightController.text),
        goal: goalController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados con éxito')),
      );

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: widget.token,
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error al guardar datos: $e';
      });

      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Inicial'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: AppStyles.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  errorMessage,
                  style: AppStyles.errorTextStyle,
                ),
              ),
            const Text(
              'Completa los datos iniciales:',
              style: AppStyles.headerTextStyle,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(
                labelText: 'Altura (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: goalController,
              decoration: const InputDecoration(
                labelText: 'Objetivo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
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
