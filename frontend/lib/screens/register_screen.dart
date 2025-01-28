import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';
import '../widgets/error_message.dart';
import '../utils/styles.dart';

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

  File? avatarFile; // Archivo para móviles
  Uint8List? avatarBytes; // Bytes para Flutter Web
  final ImagePicker _picker = ImagePicker();

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

  // Seleccionar avatar
  Future<void> pickAvatar() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (kIsWeb) {
            pickedFile.readAsBytes().then((bytes) {
              avatarBytes = bytes; // Asignar bytes para web
              avatarFile = null; // Asegurarse de que no se usa `avatarFile`
            });
          } else {
            avatarFile = File(pickedFile.path); // Asignar archivo para móvil
            avatarBytes = null; // Asegurarse de que no se usan bytes
          }
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al seleccionar la imagen: $e';
      });
    }
  }

  // Función para registrar al usuario
  void register() async {
    if (!validateForm()) {
      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
      return;
    }

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
        avatarFile: avatarFile,
        avatarBytes: avatarBytes,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado con éxito')),
      );
      Navigator.pop(context); // Regresa al login
    } catch (e) {
      setState(() {
        errorMessage = 'Error al registrar usuario: $e';
      });

      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.gradientBackground,
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
                    const Text(
                      'Crear Cuenta',
                      style: AppStyles.headerTextStyle,
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

                    // Vista previa del avatar seleccionado
                    if (avatarBytes != null)
                      CircleAvatar(
                        radius: AppStyles.avatarRadius, // Usa una constante centralizada
                        backgroundImage: MemoryImage(avatarBytes!),
                      )
                    else if (avatarFile != null)
                      CircleAvatar(
                        radius: AppStyles.avatarRadius, // Usa una constante centralizada
                        backgroundImage: FileImage(avatarFile!),
                      )
                    else
                      const CircleAvatar(
                        radius: AppStyles.avatarRadius, // Usa una constante centralizada
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                    TextButton(
                      onPressed: pickAvatar,
                      child: const Text('Seleccionar Avatar'),
                    ),

                    CustomButton(
                      text: 'Registrar',
                      onPressed: register,
                      isLoading: isLoading,
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
