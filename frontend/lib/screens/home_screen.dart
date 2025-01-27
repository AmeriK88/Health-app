import 'dart:convert';
import '../services/daily_status_service.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/api_service.dart';
import 'daily_status_screen.dart';
import 'initial_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  List<dynamic>? dailyStatuses;
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
      final bool missingData = data['weight'] == null ||
          data['weight'] == 0 ||
          data['height'] == null ||
          data['height'] == 0 ||
          data['goal'] == null ||
          data['goal'].isEmpty;

      if (missingData) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialSetupScreen(token: widget.token),
          ),
        );
      } else {
        setState(() {
          userData = data;
          dailyStatuses = data['daily_statuses'] ?? [];
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

  void showRecommendationSnackBar(Map<String, dynamic> dailyStatus) {
    final recommendation =
        dailyStatus['recommendation'] ?? 'Sin recomendaciones.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(recommendation),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Colors.teal, // Color del AppBar
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent], // Gradiente de fondo
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Información del usuario
                        Card(
                          color: Colors.white.withOpacity(0.9),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Información del Usuario:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.teal,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Mostrar avatar del usuario
                                if (userData?['avatar'] != null)
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(userData!['avatar']),
                                    onBackgroundImageError: (_, __) {
                                      setState(() {
                                        errorMessage =
                                            'Error al cargar la imagen del avatar.';
                                      });
                                    },
                                  )
                                else
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.person,
                                        size: 50, color: Colors.white),
                                  ),
                                const SizedBox(height: 10),
                                Text('Usuario: ${userData?['username']}'),
                                Text('Peso: ${userData?['weight']} kg'),
                                Text('Altura: ${userData?['height']} cm'),
                                Text('Objetivo: ${userData?['goal']}'),
                                const SizedBox(height: 10),
                                Text(
                                  'Estado Físico: ${userData?['physical_state']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Estados diarios
                        if (dailyStatuses != null && dailyStatuses!.isNotEmpty)
                          ...dailyStatuses!.map((status) {
                            return Card(
                              color: Colors.white.withOpacity(0.9),
                              elevation: 8,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                title: Text(
                                  'Fecha: ${status['date']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Energía: ${status['energy_level']}'),
                                    Text('Estado de Ánimo: ${status['mood']}'),
                                    Text('Dolor: ${status['has_pain'] ? 'Sí' : 'No'}'),
                                    Text('Cansancio: ${status['is_tired'] ? 'Sí' : 'No'}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  color: Colors.teal,
                                  onPressed: () =>
                                      showRecommendationSnackBar(status),
                                ),
                              ),
                            );
                          }).toList()
                        else
                          const Text(
                            'No hay estados diarios registrados.',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DailyStatusScreen(token: widget.token),
                              ),
                            ).then((_) => fetchUserData());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Registrar Estado Diario'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
