import 'package:flutter/material.dart';
import '../services/daily_status_service.dart';
import 'home_screen.dart';

class DailyStatusScreen extends StatefulWidget {
  final String token;

  const DailyStatusScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<DailyStatusScreen> createState() => _DailyStatusScreenState();
}

class _DailyStatusScreenState extends State<DailyStatusScreen> {
  String? selectedEnergyLevel;
  String? selectedMood;
  final TextEditingController notesController = TextEditingController();
  bool pain = false;
  bool tiredness = false;
  bool isLoading = false;

  final List<Map<String, String>> energyLevels = [
    {'key': 'low', 'label': 'Bajo'},
    {'key': 'medium', 'label': 'Medio'},
    {'key': 'high', 'label': 'Alto'},
  ];

  final List<Map<String, String>> moods = [
    {'key': 'bad', 'label': 'Mal'},
    {'key': 'neutral', 'label': 'Neutral'},
    {'key': 'good', 'label': 'Bien'},
  ];

  void saveStatus(BuildContext context) async {
    if (selectedEnergyLevel == null || selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona todos los campos.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      'energy_level': selectedEnergyLevel,
      'has_pain': pain,
      'is_tired': tiredness,
      'mood': selectedMood,
      'notes': notesController.text.trim(),
    };

    try {
      await registerDailyStatus(widget.token, data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado guardado con éxito')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(token: widget.token),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar estado: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Estado Diario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nivel de Energía',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedEnergyLevel,
                hint: const Text('Selecciona tu nivel de energía'),
                items: energyLevels.map((level) {
                  return DropdownMenuItem(
                    value: level['key'],
                    child: Text(level['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEnergyLevel = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Dolor',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text('¿Tienes dolor?'),
                value: pain,
                onChanged: (value) {
                  setState(() {
                    pain = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Cansancio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text('¿Estás cansado?'),
                value: tiredness,
                onChanged: (value) {
                  setState(() {
                    tiredness = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Estado de Ánimo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedMood,
                hint: const Text('Selecciona tu estado de ánimo'),
                items: moods.map((mood) {
                  return DropdownMenuItem(
                    value: mood['key'],
                    child: Text(mood['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMood = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Notas adicionales',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Añade notas opcionales',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : () => saveStatus(context),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Guardar Estado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
