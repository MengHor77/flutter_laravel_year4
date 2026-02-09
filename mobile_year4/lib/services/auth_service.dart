import 'dart:convert';
import '../api_config.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiConfig.login);
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
          "device_name": "mobile_app",
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "user": responseData['user'],
          "token": responseData['token'],
          "role": responseData['role'] ?? 'user',
        };
      } else {
        return {
          "success": false,
          "message": responseData['message'] ?? "Login failed."
        };
      }
    } catch (e) {
      return {"success": false, "message": "Connection error: $e"};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final url = Uri.parse(ApiConfig.register);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {"success": true, "message": "Success"};
      } else {
        return {"success": false, "message": data['message'] ?? "Failed"};
      }
    } catch (e) {
      return {"success": false, "message": "Connection error"};
    }
  }
}