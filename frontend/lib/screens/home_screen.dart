import 'dart:convert';
import '../services/daily_status_service.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/api_service.dart';
import 'daily_status_screen.dart';
import 'initial_setup_screen.dart';
import '../utils/styles.dart';
import '../widgets/custom_button.dart';
import 'chat_screen.dart';

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

  double calculateProgress(Map<String, dynamic> dailyStatus) {
    double progress = 0.0;
    // Calcular puntos para nivel de energía
    switch (dailyStatus['energy_level']) {
      case 'low':
        progress += 0;
        break;
      case 'medium':
        progress += 12.5;
        break;
      case 'high':
        progress += 25;
        break;
    }
    // Calcular puntos para dolor
    if (dailyStatus['has_pain'] == false) {
      progress += 25; // Sin dolor
    }
    // Calcular puntos para cansancio
    if (dailyStatus['is_tired'] == false) {
      progress += 25; // No está cansado
    }
    // Calcular puntos para estado de ánimo
    switch (dailyStatus['mood']) {
      case 'mal':
        progress += 0;
        break;
      case 'neutral':
        progress += 12.5;
        break;
      case 'bien':
        progress += 25;
        break;
    }

    return progress; // Progreso en porcentaje (0 a 100)
  }

  void showRecommendationSnackBar(Map<String, dynamic> dailyStatus) {
    final recommendation = dailyStatus['recommendation'] ?? 'Sin recomendaciones.';
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
        backgroundColor: AppStyles.primaryColor,
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
        width: double.infinity,  // Expande el contenedor al ancho total
        decoration: AppStyles.gradientBackground, // Fondo con gradiente
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: AppStyles.errorTextStyle,
                    ),
                  )
                : LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView(
                        padding: AppStyles.pagePadding,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight, // Ocupa al menos la pantalla completa
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tarjeta de información del usuario
                              Card(
                                color: Colors.white.withOpacity(0.9),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: AppStyles.pagePadding,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Información del Usuario:',
                                        style: AppStyles.headerTextStyle,
                                      ),
                                      const SizedBox(height: 10),

                                      // Avatar del usuario
                                      if (userData?['avatar'] != null)
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(userData!['avatar']),
                                          onBackgroundImageError: (_, __) {
                                            setState(() {
                                              errorMessage = 'Error al cargar la imagen del avatar.';
                                            });
                                          },
                                        )
                                      else
                                        const CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.person, size: 50, color: Colors.white),
                                        ),
                                      const SizedBox(height: 10),

                                      // Información del usuario
                                      Text('Usuario: ${userData?['username']}', style: const TextStyle(fontSize: 16)),
                                      Text('Edad: ${userData?['age'] ?? "No especificada"} años', style: const TextStyle(fontSize: 16)),
                                      Text('Bio: ${userData?['bio'] ?? "No disponible"}', style: const TextStyle(fontSize: 16)),
                                      Text('Peso: ${userData?['weight']} kg', style: const TextStyle(fontSize: 16)),
                                      Text('Altura: ${userData?['height']} cm', style: const TextStyle(fontSize: 16)),
                                      Text('Objetivo: ${userData?['goal'] ?? "No especificado"}', style: const TextStyle(fontSize: 16)),

                                      const SizedBox(height: 10),
                                      Text(
                                        'Estado Físico: ${userData?['physical_state']}',
                                        style: AppStyles.headerTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Botón para editar información
                              CustomButton(
                                text: 'Editar Información',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InitialSetupScreen(token: widget.token),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      fetchUserData();
                                    });
                                  });
                                },
                                style: AppStyles.primaryButtonStyle,
                              ),

                              const SizedBox(height: 20),

                              // Estados diarios
                              if (dailyStatuses != null && dailyStatuses!.isNotEmpty)
                                ...dailyStatuses!.map((status) {
                                  return Card(
                                    color: Colors.white.withOpacity(0.9),
                                    elevation: 8,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: AppStyles.pagePadding,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Fecha: ${status['date']}',
                                            style: AppStyles.headerTextStyle,
                                          ),
                                          const SizedBox(height: 10),

                                          // Información del estado diario
                                          Text('Energía: ${status['energy_level']}'),
                                          Text('Estado de Ánimo: ${status['mood']}'),
                                          Text('Dolor: ${status['has_pain'] ? 'Sí' : 'No'}'),
                                          Text('Cansancio: ${status['is_tired'] ? 'Sí' : 'No'}'),

                                          const SizedBox(height: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Progreso Diario:',
                                                style: AppStyles.headerTextStyle,
                                              ),
                                              const SizedBox(height: 10),

                                              // Barra de progreso
                                              LinearProgressIndicator(
                                                value: calculateProgress(status) / 100,
                                                backgroundColor: Colors.grey[300],
                                                color: calculateProgress(status) == 100
                                                    ? Colors.green
                                                    : Colors.blue,
                                                minHeight: 8,
                                              ),
                                              const SizedBox(height: 10),

                                              Text(
                                                '${calculateProgress(status).toStringAsFixed(0)}% completado',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()
                              else
                                const Text(
                                  'No hay estados diarios registrados.',
                                  style: AppStyles.errorTextStyle,
                                ),

                              const SizedBox(height: 20),

                              // Botón para registrar estado diario
                              CustomButton(
                                text: 'Registrar Estado Diario',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DailyStatusScreen(token: widget.token),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      fetchUserData();
                                    });
                                  });
                                },
                                style: AppStyles.primaryButtonStyle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),

      // Botón flotante para chat
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

}
