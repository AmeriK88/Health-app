import 'package:flutter/material.dart';
// 1. Importar Provider para usar context.read() y context.watch()
import 'package:provider/provider.dart';

import '../providers/daily_status_notifier.dart';
import '../utils/styles.dart';
import 'home_screen.dart';
import '../widgets/custom_button.dart';


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

  Future<void> saveStatus(BuildContext context) async {
    if (selectedEnergyLevel == null || selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona todos los campos.'),
        ),
      );
      return;
    }

    // Preparar data
    final Map<String, dynamic> data = {
      'energy_level': selectedEnergyLevel,
      'has_pain': pain,
      'is_tired': tiredness,
      'mood': selectedMood,
      'notes': notesController.text.trim(),
    };

    // 2. En lugar de llamar a registerDailyStatus(...),
    //    usamos el método del notifier.
    await context.read<DailyStatusNotifier>().registerDailyStatusToApi(data);

    // 3. Revisamos si hubo error
    final errorMessage = context.read<DailyStatusNotifier>().errorMessage;
    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar estado: $errorMessage')),
      );
    } else {
      // Éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado guardado con éxito')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(token: widget.token),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. Escuchamos si el notifier está en loading
    final dsNotifier = context.watch<DailyStatusNotifier>();
    final isLoading = dsNotifier.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Estado Diario'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Padding(
        padding: AppStyles.pagePadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nivel de Energía',
                style: AppStyles.headerTextStyle,
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
                style: AppStyles.headerTextStyle,
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
                style: AppStyles.headerTextStyle,
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
                style: AppStyles.headerTextStyle,
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
                style: AppStyles.headerTextStyle,
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
              CustomButton(
                text: 'Guardar Estado',
                onPressed: () => saveStatus(context),
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
