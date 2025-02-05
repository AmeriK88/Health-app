import 'package:flutter/material.dart';
import 'package:frontend/utils/styles.dart';

/// Widget que muestra una tarjeta con el estado diario del usuario.
/// Incluye información sobre energía, estado de ánimo, dolor, cansancio y una barra de progreso.
class DailyStatusCard extends StatelessWidget {
  final Map<String, dynamic> status; // Datos del estado diario del usuario.
  final double progress; // Porcentaje de progreso basado en el estado físico del usuario.
  final VoidCallback onShowRecommendation; // Función para mostrar la recomendación basada en el estado.

  const DailyStatusCard({
    Key? key,
    required this.status,
    required this.progress,
    required this.onShowRecommendation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9), // Fondo con opacidad para mejorar el contraste.
      elevation: 8, // Agrega sombra para resaltar la tarjeta.
      margin: const EdgeInsets.symmetric(vertical: 8), // Espaciado vertical entre tarjetas.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bordes redondeados para un diseño moderno.
      ),
      child: Padding(
        padding: AppStyles.pagePadding, // Usa el padding predefinido en los estilos.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fecha del estado diario
            Text('Fecha: ${status['date']}', style: AppStyles.headerTextStyle),
            const SizedBox(height: 10),

            // Información del estado diario del usuario
            Text('Energía: ${status['energy_level']}'),
            Text('Estado de Ánimo: ${status['mood']}'),
            Text('Dolor: ${status['has_pain'] ? 'Sí' : 'No'}'),
            Text('Cansancio: ${status['is_tired'] ? 'Sí' : 'No'}'),

            const SizedBox(height: 10),

            // Botón de recomendación con un icono de bombilla
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.lightbulb, color: Colors.blueAccent),
                tooltip: "Ver recomendación", // Tooltip al pasar el cursor sobre el botón.
                onPressed: onShowRecommendation,
              ),
            ),

            // Barra de progreso del estado diario
            LinearProgressIndicator(
              value: progress / 100, // Convierte el porcentaje en un valor entre 0 y 1.
              backgroundColor: Colors.grey[300], // Color de fondo de la barra.
              color: progress == 100 ? Colors.green : Colors.blue, // Verde si está al 100%, azul si no.
              minHeight: 8, // Altura de la barra de progreso.
            ),
            const SizedBox(height: 10),

            // Texto con el porcentaje de progreso
            Text(
              '${progress.toStringAsFixed(0)}% completado',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
