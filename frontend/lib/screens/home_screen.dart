import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/daily_status_service.dart';
import '../utils/styles.dart';
import '../widgets/buttons/custom_button.dart';
import '../widgets/cards/user_info_card.dart';
import '../widgets/cards/daily_status_card.dart';
import 'initial_setup_screen.dart';
import 'daily_status_screen.dart';
import 'login_screen.dart';
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

      print("Datos recibidos del servidor: ${jsonEncode(data)}");

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
    if (!dailyStatus['has_pain']) progress += 25;
    if (!dailyStatus['is_tired']) progress += 25;
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
    return progress;
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
        flexibleSpace: Container(
        decoration: AppStyles.gradientBackground,
        ),
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
        width: double.infinity,
        decoration: AppStyles.gradientBackground,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: AppStyles.errorTextStyle,
                    ),
                  )
                : SingleChildScrollView(
                    padding: AppStyles.pagePadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tarjeta de usuario
                        UserInfoCard(
                          userData: userData,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InitialSetupScreen(token: widget.token),
                              ),
                            ).then((_) => fetchUserData());
                          },
                        ),

                        const SizedBox(height: 20),

                        // Estados diarios
                        if (dailyStatuses != null && dailyStatuses!.isNotEmpty)
                          Column(
                            children: dailyStatuses!.map((status) {
                              return DailyStatusCard(
                                status: status,
                                progress: calculateProgress(status),
                                onShowRecommendation: () => showRecommendationSnackBar(status),
                              );
                            }).toList(),
                          )
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
                            ).then((_) => fetchUserData());
                          },
                          style: AppStyles.primaryButtonStyle,
                        ),
                      ],
                    ),
                  ),
      ),
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
