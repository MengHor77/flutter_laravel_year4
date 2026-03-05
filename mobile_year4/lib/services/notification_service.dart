import 'dart:convert';
import '../api_config.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  // ទាញយក Notification ទាំងអស់
  static Future<http.Response> fetchAll() async {
    return await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/notifications"),
      headers: ApiConfig.getHeaders(),
    );
  }

  // កំណត់ថាអានរួច
  static Future<http.Response> markAsRead(String id) async {
    return await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/notifications/$id/read"),
      headers: ApiConfig.getHeaders(),
    );
  }

  // លុប Notification
  static Future<http.Response> delete(String id) async {
    return await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/api/notifications/$id"),
      headers: ApiConfig.getHeaders(),
    );
  }
}
