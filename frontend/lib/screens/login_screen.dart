import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/daily_status_notifier.dart';
import '../services/api_service.dart';
import '../services/daily_status_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'daily_status_screen.dart';
import '../widgets/buttons/custom_button.dart';
import '../widgets/inputs/input_field.dart';
import '../widgets/feedback/error_message.dart';
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

  void login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Por favor, completa todos los campos.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final token = await apiService.login(usernameController.text, passwordController.text);
      context.read<DailyStatusNotifier>().setToken(token);

      final todayStatuses = await fetchDailyStatuses(token);
      final bool hasTodayStatus = todayStatuses.any((status) {
        final statusDate = DateTime.parse(status['date']);
        final now = DateTime.now();
        return statusDate.year == now.year && statusDate.month == now.month && statusDate.day == now.day;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => hasTodayStatus ? HomeScreen(token: token) : DailyStatusScreen(token: token),
        ),
      );
    } catch (e) {
      setState(() => errorMessage = 'Error al iniciar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() => isLoading = false);
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
              elevation: 10, // 🔥 Aumentamos la elevación para más profundidad
              shadowColor: Colors.black.withOpacity(0.2), // ✅ Sombra más realista
              margin: AppStyles.cardMargin,
              shape: AppStyles.cardBorderStyle,
              child: Padding(
                padding: AppStyles.cardPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/avatar.png', height: 100),
                    const SizedBox(height: 20),

                    // 🏆 ✅ Mejoramos el título con mayor tamaño y estilo
                    Text(
                      'Iniciar Sesión',
                      style: AppStyles.loginHeaderTextStyle.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 10),

                    if (errorMessage.isNotEmpty) ErrorMessage(message: errorMessage),
                    const SizedBox(height: 10),

                    // 📌 Mejoramos la separación de los inputs
                    InputField(
                      controller: usernameController,
                      label: 'Usuario',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 15), // 🔥 Más espacio entre inputs
                    InputField(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    // 📌 Usamos el estilo de botón definido en `AppStyles`
                    CustomButton(
                      text: 'Iniciar Sesión',
                      onPressed: login,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 10),

                    // 📌 Hacemos el texto del botón más grande y centrado
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      ),
                      child: const Text(
                        '¿No tienes cuenta? Regístrate aquí',
                        style: AppStyles.linkTextStyle,
                        textAlign: TextAlign.center,
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
