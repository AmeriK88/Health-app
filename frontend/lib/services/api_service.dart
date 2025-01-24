import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api/users/';

  // Registro de usuario con posibilidad de enviar avatar
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required int age,
    required String bio,
    double? weight,
    double? height,
    String? goal,
    File? avatar, // Archivo de imagen opcional
  }) async {
    var uri = Uri.parse('${baseUrl}register/');
    var request = http.MultipartRequest('POST', uri);

    // Campos normales
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['age'] = age.toString();
    request.fields['bio'] = bio;
    if (weight != null) request.fields['weight'] = weight.toString();
    if (height != null) request.fields['height'] = height.toString();
    if (goal != null) request.fields['goal'] = goal;

    // Archivo (opcional)
    if (avatar != null) {
      final fileName = p.basename(avatar.path);
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        avatar.path,
        filename: fileName,
      ));
    }

    // Enviar la solicitud
    var streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 201) {
      throw Exception('Error al registrar el usuario: $responseBody');
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

  // Obtener datos del dashboard
  Future<Map<String, dynamic>> getDashboard(String token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}dashboard/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener el dashboard: ${response.body}');
    }
  }

  // Actualizar datos del usuario
  Future<void> updateUserData({
    required String token,
    double? weight,
    double? height,
    String? goal,
    File? avatar, // Posibilidad de actualizar avatar
  }) async {
    var uri = Uri.parse('${baseUrl}dashboard/');
    var request = http.MultipartRequest('PUT', uri);

    // Agregar token en los headers
    request.headers['Authorization'] = 'Bearer $token';

    // Campos opcionales
    if (weight != null) request.fields['weight'] = weight.toString();
    if (height != null) request.fields['height'] = height.toString();
    if (goal != null) request.fields['goal'] = goal;

    // Archivo (opcional)
    if (avatar != null) {
      final fileName = p.basename(avatar.path);
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        avatar.path,
        filename: fileName,
      ));
    }

    // Enviar la solicitud
    var streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      throw Exception('Error al actualizar datos: $responseBody');
    }
  }
}
