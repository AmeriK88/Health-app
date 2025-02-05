import 'package:flutter/material.dart';
import 'package:frontend/utils/styles.dart';
import 'package:frontend/widgets/buttons/custom_button.dart';


class UserInfoCard extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback onEdit;

  const UserInfoCard({
    Key? key,
    required this.userData,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Text('Información del Usuario:', style: AppStyles.headerTextStyle),
            const SizedBox(height: 10),

            // Avatar del usuario
            if (userData?['avatar'] != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userData!['avatar']),
              )
            else
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
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

            // ✅ Estado físico
            if (userData?['physical_state'] != null)
              Text(
                'Estado físico: ${userData!['physical_state']}',
                style: AppStyles.subHeaderTextStyle.copyWith(
                  color: AppStyles.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 10),

            // Botón de editar
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                text: "Editar Información",
                onPressed: onEdit,
                isLoading: false, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
