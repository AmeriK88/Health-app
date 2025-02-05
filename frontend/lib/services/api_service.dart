import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

///  **Clase ApiService**
/// - Gestiona las solicitudes HTTP a la API backend.
/// - Incluye métodos para registrar usuarios, iniciar sesión y obtener datos del usuario.
/// - Utiliza http para manejar las peticiones y path para gestionar archivos.
class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api/users/';

  ///  **Manejo de errores HTTP**
  /// - Lanza una excepción si la respuesta HTTP tiene un código de error.
  Future<void> _handleError(http.Response response) async {
    if (response.statusCode >= 400) {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  ///  **Registro de usuario**
  /// - Envía los datos del usuario a la API para registrarlo.
  /// - Permite subir un avatar opcionalmente.
  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String emailConfirm,
    required String password,
    required String passwordConfirm,
    required int age,
    required String bio,
    File? avatarFile,
    Uint8List? avatarBytes,
  }) async {
    var uri = Uri.parse('${baseUrl}register/');
    var request = http.MultipartRequest('POST', uri);

    //  Asigna los datos del usuario al formulario
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['email_confirm'] = emailConfirm;
    request.fields['password'] = password;
    request.fields['password_confirm'] = passwordConfirm;
    request.fields['age'] = age.toString();
    request.fields['bio'] = bio;

    //  Manejo del archivo de avatar (si se proporciona)
    if (avatarFile != null) {
      final fileName = p.basename(avatarFile.path);
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        avatarFile.path,
        filename: fileName,
      ));
    } else if (avatarBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'avatar',
        avatarBytes,
        filename: 'avatar.jpg',
      ));
    }

    //  Enviar la solicitud a la API
    var streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 201) {
      throw Exception('Error al registrar el usuario: $responseBody');
    }
  }

  ///  **Inicio de sesión**
  /// - Envía las credenciales a la API para obtener un token de acceso.
  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}token/'),
      body: {
        'username': username,
        'password': password,
      },
    );

    await _handleError(response);
    final data = jsonDecode(response.body);
    return data['access']; //  Devuelve el token de acceso
  }

  ///  **Obtener datos del usuario (dashboard)**
  /// - Recupera la información del usuario autenticado.
  Future<Map<String, dynamic>> getDashboard(String token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}dashboard/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    await _handleError(response);

    //  Decodificar correctamente la respuesta en UTF-8
    final decoded = utf8.decode(response.bodyBytes);
    return jsonDecode(decoded);
  }

  ///  **Actualizar datos del usuario**
  /// - Permite modificar el peso, altura, objetivo y avatar del usuario.
  Future<void> updateUserData({
    required String token,
    double? weight,
    double? height,
    String? goal,
    File? avatar,
  }) async {
    var uri = Uri.parse('${baseUrl}dashboard/');
    var request = http.MultipartRequest('PUT', uri);

    request.headers['Authorization'] = 'Bearer $token';

    //  Agregar datos si están presentes
    if (weight != null) request.fields['weight'] = weight.toString();
    if (height != null) request.fields['height'] = height.toString();
    if (goal != null) request.fields['goal'] = goal;

    //  Manejo del avatar si se proporciona un nuevo archivo
    if (avatar != null) {
      final fileName = p.basename(avatar.path);
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        avatar.path,
        filename: fileName,
      ));
    }

    //  Enviar solicitud de actualización
    var streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      throw Exception('Error al actualizar datos: $responseBody');
    }
  }
}
