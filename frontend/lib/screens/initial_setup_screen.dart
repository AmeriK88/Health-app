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

    // Navegación 
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: widget.token, // Pasar el token como argumento
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Altura (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: goalController,
              decoration: const InputDecoration(labelText: 'Objetivo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveData,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
