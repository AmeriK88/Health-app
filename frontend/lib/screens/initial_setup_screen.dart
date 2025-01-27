import 'package:flutter/material.dart';
import '../services/api_service.dart';

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

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: widget.token,
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error al guardar datos: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración Inicial')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const Text(
              'Completa los datos iniciales:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveData,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
