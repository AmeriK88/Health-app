import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';
import '../widgets/error_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiService apiService = ApiService();

  // Controladores
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  // Variables para validaciones
  bool isLoading = false;
  String errorMessage = '';

  // Validaciones
  bool validateForm() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        ageController.text.isEmpty ||
        bioController.text.isEmpty) {
      setState(() => errorMessage = 'Todos los campos son obligatorios.');
      return false;
    }

    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+").hasMatch(emailController.text)) {
      setState(() => errorMessage = 'Correo electrónico no válido.');
      return false;
    }

    if (int.tryParse(ageController.text) == null) {
      setState(() => errorMessage = 'Edad debe ser un número.');
      return false;
    }

    if (passwordController.text.length < 6) {
      setState(() => errorMessage = 'Contraseña debe tener al menos 6 caracteres.');
      return false;
    }

    return true;
  }

  // Función para registrar al usuario
  void register() async {
    if (!validateForm()) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await apiService.registerUser(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        age: int.parse(ageController.text),
        bio: bioController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado con éxito')),
      );
      Navigator.pop(context); // Regresa al login
    } catch (e) {
      setState(() => errorMessage = 'Error al registrar usuario: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo con gradiente
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.tealAccent, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset('assets/avatar.png', height: 100),
                    const SizedBox(height: 20),

                    // Título
                    const Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Mensaje de error
                    if (errorMessage.isNotEmpty)
                      ErrorMessage(message: errorMessage),
                    const SizedBox(height: 10),

                    // Campos de entrada
                    InputField(
                      controller: usernameController,
                      label: 'Usuario',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),

                    InputField(
                      controller: emailController,
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),

                    InputField(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),

                    InputField(
                      controller: ageController,
                      label: 'Edad',
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),

                    InputField(
                      controller: bioController,
                      label: 'Biografía',
                      icon: Icons.info,
                    ),
                    const SizedBox(height: 20),

                    // Botón de registro reutilizable
                    CustomButton(
                      text: 'Registrar',
                      onPressed: register,
                      isLoading: isLoading,
                      color: Colors.teal,
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
