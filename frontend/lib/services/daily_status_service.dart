import 'package:http/http.dart' as http;
import 'dart:convert';

/// Base URL para la API
const String baseUrl = 'http://127.0.0.1:8000/api/daily_status/status/';

/// Registra el estado diario del usuario
Future<void> registerDailyStatus(String token, Map<String, dynamic> data) async {
  final url = Uri.parse(baseUrl);

  try {
    if (!data.containsKey('energy_level') || data['energy_level'] == null) {
      throw Exception('Nivel de energía no especificado.');
    }
    if (!data.containsKey('mood') || data['mood'] == null) {
      throw Exception('Estado de ánimo no especificado.');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': "Bearer $token",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );


    if (response.statusCode == 201) {
      print('Estado diario registrado con éxito: ${response.body}');
    } else {
      throw Exception('Error al registrar estado: ${response.body}');
    }
  } catch (e) {
    print('Error en registerDailyStatus: $e');
    rethrow;
  }
}

/// Obtiene los estados diarios del usuario
Future<List<dynamic>> fetchDailyStatuses(String token) async {
  final url = Uri.parse(baseUrl);

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener estados: ${response.body}');
    }
  } catch (e) {
    print('Error en fetchDailyStatuses: $e');
    rethrow;
  }
}
