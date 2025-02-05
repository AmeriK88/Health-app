import 'package:flutter/material.dart';
import 'package:frontend/utils/styles.dart';
import 'package:frontend/widgets/buttons/custom_button.dart';

/// Widget para mostrar la información del usuario en una tarjeta.
/// Incluye datos como avatar, nombre de usuario, edad, peso, altura, estado físico y un botón para editar la información.
class UserInfoCard extends StatelessWidget {
  final Map<String, dynamic>? userData; // Datos del usuario obtenidos desde el backend.
  final VoidCallback onEdit; // Función que se ejecuta al presionar el botón de editar.

  const UserInfoCard({
    Key? key,
    required this.userData,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9), // Fondo semitransparente .
      elevation: 8, // Agrega sombra para mejorar la visibilidad de la tarjeta.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bordes redondeados.
      ),
      child: Padding(
        padding: AppStyles.pagePadding, // Espaciado uniforme alrededor del contenido.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la tarjeta
            Text('Información del Usuario:', style: AppStyles.headerTextStyle),
            const SizedBox(height: 10),

            // Avatar del usuario
            if (userData?['avatar'] != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userData!['avatar']), // Carga la imagen del usuario si está disponible.
              )
            else
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey, // Muestra un avatar gris si el usuario no tiene imagen.
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            const SizedBox(height: 10),

            // Información del usuario
            Text('Usuario: ${userData?['username'] ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Edad: ${userData?['age'] ?? "No especificada"} años', style: const TextStyle(fontSize: 16)),
            Text('Bio: ${userData?['bio'] ?? "No disponible"}', style: const TextStyle(fontSize: 16)),
            Text('Peso: ${userData?['weight']} kg', style: const TextStyle(fontSize: 16)),
            Text('Altura: ${userData?['height']} cm', style: const TextStyle(fontSize: 16)),
            Text('Objetivo: ${userData?['goal'] ?? "No especificado"}', style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            // Estado físico basado en el IMC (si está disponible)
            if (userData?['physical_state'] != null)
              Text(
                'Estado físico: ${userData!['physical_state']}',
                style: AppStyles.subHeaderTextStyle.copyWith(
                  color: AppStyles.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 10),

            // Botón de editar información del usuario
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                text: "Editar Información",
                onPressed: onEdit, // Llama a la función que permite editar los datos del usuario.
                isLoading: false, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
