import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api/';

  // Registro de usuario
  Future<void> registerUser(String username, String email, String password, int age, String bio) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register/'),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'age': age,
        'bio': bio,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Error al registrar el usuario: ${response.body}');
    }
  }

  // Login de usuario
  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}token/'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access']; // Devuelve el token de acceso
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  // Probar la conexión autenticada
  Future<String> testConnection(String token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}test/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message']; // Por ejemplo, "Conexión exitosa"
    } else {
      throw Exception('Error de conexión: ${response.body}');
    }
  }
}
