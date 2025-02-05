import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../widgets/buttons/custom_button.dart';
import '../widgets/inputs/input_field.dart';
import '../widgets/feedback/error_message.dart';
import '../utils/styles.dart';

///  **Pantalla de Registro de Usuario**
/// - Permite al usuario ingresar su información personal para registrarse.
/// - Incluye validaciones en los campos del formulario.
/// - Permite la selección de un avatar.
/// - Si el registro es exitoso, redirige al usuario de vuelta a la pantalla de inicio de sesión.

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiService apiService = ApiService();

  ///  **Controladores para capturar los datos ingresados**
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailConfirmController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File? avatarFile;
  Uint8List? avatarBytes;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false; //  Indica si el registro está en proceso
  String errorMessage = ''; //  Mensaje de error si ocurre algún problema

  ///  **Validación del formulario**
  /// - Verifica que todos los campos requeridos estén completos.
  /// - Asegura que el email y la confirmación coincidan.
  /// - Asegura que la contraseña sea segura y coincida con la confirmación.
  bool validateForm() {
    setState(() => errorMessage = '');

    if ([
      firstNameController.text,
      lastNameController.text,
      usernameController.text,
      emailController.text,
      emailConfirmController.text,
      passwordController.text,
      passwordConfirmController.text,
      ageController.text,
      bioController.text
    ].any((text) => text.isEmpty)) {
      errorMessage = 'Todos los campos son obligatorios.';
      return false;
    }

    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+").hasMatch(emailController.text)) {
      errorMessage = 'Correo electrónico no válido.';
      return false;
    }

    if (emailController.text != emailConfirmController.text) {
      errorMessage = 'Los correos electrónicos no coinciden.';
      return false;
    }

    if (int.tryParse(ageController.text) == null) {
      errorMessage = 'Edad debe ser un número.';
      return false;
    }

    if (passwordController.text.length < 6) {
      errorMessage = 'La contraseña debe tener al menos 6 caracteres.';
      return false;
    }

    if (passwordController.text != passwordConfirmController.text) {
      errorMessage = 'Las contraseñas no coinciden.';
      return false;
    }

    return true;
  }

  ///  **Selección del Avatar**
  /// - Permite al usuario elegir una imagen desde la galería.
  Future<void> pickAvatar() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (kIsWeb) {
            pickedFile.readAsBytes().then((bytes) => avatarBytes = bytes);
            avatarFile = null;
          } else {
            avatarFile = File(pickedFile.path);
            avatarBytes = null;
          }
        });
      }
    } catch (e) {
      setState(() => errorMessage = 'Error al seleccionar la imagen: $e');
    }
  }

  ///  **Registro del usuario**
  /// - Envía los datos a la API para registrar al usuario.
  /// - Muestra un mensaje de éxito o error según el resultado.
  void register() async {
    if (!validateForm()) {
      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
      return;
    }

    setState(() => isLoading = true);

    try {
      await apiService.registerUser(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        username: usernameController.text,
        email: emailController.text,
        emailConfirm: emailConfirmController.text,
        password: passwordController.text,
        passwordConfirm: passwordConfirmController.text,
        age: int.parse(ageController.text),
        bio: bioController.text,
        avatarFile: avatarFile,
        avatarBytes: avatarBytes,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario registrado con éxito')));
      Navigator.pop(context);
    } catch (e) {
      setState(() => errorMessage = 'Error al registrar usuario: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///  **Fondo con gradiente **
      body: Container(
        decoration: AppStyles.gradientBackground,
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10, 
              shadowColor: Colors.black.withOpacity(0.2),
              margin: AppStyles.cardMargin,
              shape: AppStyles.cardBorderStyle,
              child: Padding(
                padding: AppStyles.cardPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///  **Título**
                    const Text(
                      'Crear Cuenta',
                      style: AppStyles.headerTextStyle,
                    ),
                    const SizedBox(height: 10),

                    ///  **Mensaje de error**
                    if (errorMessage.isNotEmpty)
                      ErrorMessage(message: errorMessage),
                    const SizedBox(height: 10),

                    //  **Campos del formulario**
                    InputField(controller: firstNameController, label: 'Nombre', icon: Icons.person),
                    const SizedBox(height: 10),
                    InputField(controller: lastNameController, label: 'Apellidos', icon: Icons.person),
                    const SizedBox(height: 10),
                    InputField(controller: usernameController, label: 'Usuario', icon: Icons.person),
                    const SizedBox(height: 10),
                    InputField(controller: emailController, label: 'Correo Electrónico', icon: Icons.email),
                    const SizedBox(height: 10),
                    InputField(controller: emailConfirmController, label: 'Confirmar Correo', icon: Icons.email),
                    const SizedBox(height: 10),
                    InputField(controller: passwordController, label: 'Contraseña', icon: Icons.lock, obscureText: true),
                    const SizedBox(height: 10),
                    InputField(controller: passwordConfirmController, label: 'Confirmar Contraseña', icon: Icons.lock, obscureText: true),
                    const SizedBox(height: 10),
                    InputField(controller: ageController, label: 'Edad', icon: Icons.cake, keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    InputField(controller: bioController, label: 'Biografía', icon: Icons.info),
                    const SizedBox(height: 20),

                    ///  **Avatar**
                    GestureDetector(
                      onTap: pickAvatar,
                      child: CircleAvatar(
                        radius: AppStyles.avatarRadius,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: avatarBytes != null
                            ? MemoryImage(avatarBytes!)
                            : avatarFile != null
                                ? FileImage(avatarFile!)
                                : null,
                        child: avatarBytes == null && avatarFile == null
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    TextButton(onPressed: pickAvatar, child: const Text('Seleccionar Avatar')),
                    const SizedBox(height: 20),

                    ///  **Botón de Registro**
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
