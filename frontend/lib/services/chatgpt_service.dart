import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatGPTService {
  // En este ejemplo, cargamos la key desde dotenv
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage({
    required List<Map<String, String>> messages,
  }) async {
    // messages es una lista del estilo:
    // [ {"role": "system", "content": "..."},
    //   {"role": "user",   "content": "..."},
    // ]
    // Donde "role" puede ser "system", "user" o "assistant".

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": messages,
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String content = jsonResponse['choices'][0]['message']['content'];
        return content.trim();
      } else {
        // Manejar error
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
