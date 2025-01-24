import 'dart:convert';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/api_service.dart';
import 'initial_setup_screen.dart'; // Nueva pantalla para la configuración inicial

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
  try {
    final data = await ApiService().getDashboard(widget.token);

    // Verifica si faltan datos esenciales
    final bool missingData = data['weight'] == null ||
        data['weight'] == 0 ||
        data['height'] == null ||
        data['height'] == 0 ||
        data['goal'] == null ||
        data['goal'].isEmpty;

    if (missingData) {
      // Redirigir a la pantalla de configuración inicial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InitialSetupScreen(token: widget.token),
        ),
      );
    } else {
      setState(() {
        userData = data;
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'Error al obtener datos: $e';
      isLoading = false;
    });
  }
}


  // Método para mostrar el formulario de edición
  void showEditForm() {
    final TextEditingController weightController =
        TextEditingController(text: userData?['weight']?.toString() ?? '');
    final TextEditingController heightController =
        TextEditingController(text: userData?['height']?.toString() ?? '');
    final TextEditingController goalController =
        TextEditingController(text: userData?['goal'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Datos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
              ),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
              ),
              TextField(
                controller: goalController,
                decoration: const InputDecoration(labelText: 'Objetivo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Llama a la API para actualizar los datos
                try {
                  await ApiService().updateUserData(
                    token: widget.token,
                    weight: double.tryParse(weightController.text),
                    height: double.tryParse(heightController.text),
                    goal: goalController.text,
                  );
                  fetchUserData(); // Actualiza los datos después de editar
                  Navigator.pop(context);
                } catch (e) {
                  setState(() => errorMessage = 'Error al actualizar datos: $e');
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.purple],
                    ),
                  ),
                  child: Center(
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (userData?['avatar'] != null)
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(userData!['avatar']),
                              )
                            else
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/avatar.png'),
                              ),
                            const SizedBox(height: 20),
                            Text(
                              'Bienvenido, ${userData?['username'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Estado físico: ${userData?['physical_state'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Edad: ${userData?['age'] ?? ''} años',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Peso: ${userData?['weight'] ?? ''} kg',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Altura: ${userData?['height'] ?? ''} cm',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Objetivo: ${userData?['goal'] ?? ''}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: showEditForm,
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar Datos'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
