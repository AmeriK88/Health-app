import 'package:flutter/material.dart';
import '../services/daily_status_service.dart';

class DailyStatusScreen extends StatelessWidget {
  final String token;

  DailyStatusScreen({required this.token});

  final TextEditingController energyController = TextEditingController();
  final TextEditingController moodController = TextEditingController();
  bool pain = false;
  bool tiredness = false;

  void saveStatus(BuildContext context) async {
    Map<String, dynamic> data = {
      'energy_level': energyController.text,
      'pain': pain,
      'tiredness': tiredness,
      'mood': moodController.text,
      'notes': 'Notas opcionales', // Agrega más campos si es necesario
    };

    try {
      await registerDailyStatus(token, data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado guardado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar estado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Estado Diario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: energyController,
              decoration: InputDecoration(labelText: 'Nivel de energía (low, medium, high)'),
            ),
            SwitchListTile(
              title: Text('¿Tienes dolor?'),
              value: pain,
              onChanged: (value) => pain = value,
            ),
            SwitchListTile(
              title: Text('¿Estás cansado?'),
              value: tiredness,
              onChanged: (value) => tiredness = value,
            ),
            TextField(
              controller: moodController,
              decoration: InputDecoration(labelText: 'Estado de ánimo (bad, neutral, good)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => saveStatus(context),
              child: Text('Guardar Estado'),
            ),
          ],
        ),
      ),
    );
  }
}
