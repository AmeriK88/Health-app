import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/daily_status_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'daily_status_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';
import '../widgets/error_message.dart';
import '../utils/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  Future<void> handleRedirection(String token) async {
    try {
      final todayStatuses = await fetchDailyStatuses(token);

      final bool hasTodayStatus = todayStatuses.any((status) {
        final statusDate = DateTime.parse(status['date']);
        final now = DateTime.now();
        return statusDate.year == now.year &&
            statusDate.month == now.month &&
            statusDate.day == now.day;
      });

      if (hasTodayStatus) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DailyStatusScreen(token: token)),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al verificar estados diarios: $e';
      });
    }
  }

  void login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Por favor, completa todos los campos.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final token = await apiService.login(
        usernameController.text,
        passwordController.text,
      );
      await handleRedirection(token);
    } catch (e) {
      setState(() {
        errorMessage = 'Error al iniciar sesión: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.loginGradientBackground,
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              margin: AppStyles.cardMargin,
              shape: AppStyles.cardBorderStyle,
              child: Padding(
                padding: AppStyles.cardPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/avatar.png', height: 100),
                    const SizedBox(height: 20),
                    const Text(
                      'Iniciar Sesión',
                      style: AppStyles.loginHeaderTextStyle,
                    ),
                    const SizedBox(height: 10),
                    if (errorMessage.isNotEmpty)
                      ErrorMessage(message: errorMessage),
                    const SizedBox(height: 10),
                    InputField(
                      controller: usernameController,
                      label: 'Usuario',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Iniciar Sesión',
                      onPressed: login,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        '¿No tienes cuenta? Regístrate aquí',
                        style: AppStyles.linkTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
