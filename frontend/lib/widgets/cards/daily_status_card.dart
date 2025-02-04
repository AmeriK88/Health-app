import 'package:flutter/material.dart';
import 'package:frontend/utils/styles.dart';

class DailyStatusCard extends StatelessWidget {
  final Map<String, dynamic> status;
  final double progress;
  final VoidCallback onShowRecommendation;

  const DailyStatusCard({
    Key? key,
    required this.status,
    required this.progress,
    required this.onShowRecommendation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: AppStyles.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${status['date']}', style: AppStyles.headerTextStyle),
            const SizedBox(height: 10),

            // Información del estado diario
            Text('Energía: ${status['energy_level']}'),
            Text('Estado de Ánimo: ${status['mood']}'),
            Text('Dolor: ${status['has_pain'] ? 'Sí' : 'No'}'),
            Text('Cansancio: ${status['is_tired'] ? 'Sí' : 'No'}'),

            const SizedBox(height: 10),

            // Icono de bombilla para recomendación
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.lightbulb, color: Colors.blueAccent),
                tooltip: "Ver recomendación",
                onPressed: onShowRecommendation,
              ),
            ),

            // Barra de progreso
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[300],
              color: progress == 100 ? Colors.green : Colors.blue,
              minHeight: 8,
            ),
            const SizedBox(height: 10),

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
