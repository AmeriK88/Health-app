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

///  **Pantalla de Inicio de Sesión**
/// - Permite al usuario ingresar su **usuario y contraseña**.
/// - Si los datos son correctos, obtiene un token de autenticación.
/// - Después de iniciar sesión, redirige al usuario a HomeScreen o DailyStatusScreen según corresponda.
/// - Si la autenticación falla, muestra un mensaje de error.

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService();

  ///  **Controladores para capturar los datos ingresados**
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = ''; //  Mensaje de error si ocurre algún problema
  bool isLoading = false; //  Indica si el proceso de login está en curso

  ///  **Proceso de Inicio de Sesión**
  /// - Valida que los campos no estén vacíos.
  /// - Llama a la API para obtener el token.
  /// - Verifica si el usuario ya ha registrado su estado diario hoy.
  /// - Redirige al usuario a la pantalla correspondiente.
  void login() async {
    // 1️⃣ **Validar que los campos no estén vacíos**
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Por favor, completa todos los campos.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    // 2️⃣ **Mostrar indicador de carga**
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // 3️⃣ **Obtener token desde la API**
      final token = await apiService.login(usernameController.text, passwordController.text);
      
      // Guardar token en el DailyStatusNotifier
      context.read<DailyStatusNotifier>().setToken(token);

      // 4️⃣ **Verificar si el usuario ya ha registrado su estado hoy**
      final todayStatuses = await fetchDailyStatuses(token);
      final bool hasTodayStatus = todayStatuses.any((status) {
        final statusDate = DateTime.parse(status['date']);
        final now = DateTime.now();
        return statusDate.year == now.year && statusDate.month == now.month && statusDate.day == now.day;
      });

      // **Mensaje de éxito**
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso')),
      );

      //  **Redirigir a HomeScreen o DailyStatusScreen**
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => hasTodayStatus ? HomeScreen(token: token) : DailyStatusScreen(token: token),
        ),
      );
    } catch (e) {
      //  **Manejo de errores**
      setState(() => errorMessage = 'Error al iniciar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      //  **Ocultar indicador de carga**
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔹 **Fondo con gradiente para mejorar el diseño**
      body: Container(
        decoration: AppStyles.loginGradientBackground,
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10, //  Más profundidad con sombra
              shadowColor: Colors.black.withOpacity(0.2),
              margin: AppStyles.cardMargin,
              shape: AppStyles.cardBorderStyle,
              child: Padding(
                padding: AppStyles.cardPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  **Avatar de usuario**
                    Image.asset('assets/avatar.png', height: 100),
                    const SizedBox(height: 20),

                    //  **Título del formulario**
                    Text(
                      'Iniciar Sesión',
                      style: AppStyles.loginHeaderTextStyle.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 10),

                    ///  **Mensaje de error si existe**
                    if (errorMessage.isNotEmpty) ErrorMessage(message: errorMessage),
                    const SizedBox(height: 10),

                    ///  **Campo de entrada: Usuario**
                    InputField(
                      controller: usernameController,
                      label: 'Usuario',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 15),

                    ///  **Campo de entrada: Contraseña**
                    InputField(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    ///  **Botón de Iniciar Sesión**
                    CustomButton(
                      text: 'Iniciar Sesión',
                      onPressed: login,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 10),

                    ///  **Redirección a la pantalla de registro**
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
