import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api/users/';

  Future<void> _handleError(http.Response response) async {
    if (response.statusCode >= 400) {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required int age,
    required String bio,
    double? weight,
    double? height,
    String? goal,
    File? avatar,
  }) async {
    var uri = Uri.parse('${baseUrl}register/');
    var request = http.MultipartRequest('POST', uri);

    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['age'] = age.toString();
    request.fields['bio'] = bio;

    if (weight != null) request.fields['weight'] = weight.toString();
    if (height != null) request.fields['height'] = height.toString();
    if (goal != null) request.fields['goal'] = goal;

    if (avatar != null) {
      final fileName = p.basename(avatar.path);
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        avatar.path,
        filename: fileName,
      ));
    }

    var streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 201) {
      throw Exception('Error al registrar el usuario: $responseBody');
    }
  }

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
    return data['access'];
  }

  Future<Map<String, dynamic>> getDashboard(String token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}dashboard/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    await _handleError(response);
    return jsonDecode(response.body);
  }

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

    if (weight != null) request.fields['weight'] = weight.toString();
    if (height != null) request.fields['height'] = height.toString();
    if (goal != null) request.fields['goal'] = goal;

    if (avatar != null) {
      final fileName = p.basename(avatar.path);
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        avatar.path,
        filename: fileName,
      ));
    }

    var streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      throw Exception('Error al actualizar datos: $responseBody');
    }
  }
}
