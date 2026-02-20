import 'dart:convert';
import '../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  // User Data
  int? userId;
  String userName = "";
  String userEmail = "";
  bool isLoading = false;

  /// Update user profile logic
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    // Safety check: cannot update if we don't have a user ID
    if (userId == null) {
      debugPrint("Error: User ID is null. Cannot update profile.");
      return false;
    }

    _setLoading(true);

    // Construct URL: http://192.168.1.104:8000/api/users/{id}
    final url = Uri.parse("${ApiConfig.users}/$userId");

    try {
      final response = await http.put(
        url,
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      // Log the response for debugging
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sync local variables with the database response
        userName = data['user']['name'];
        userEmail = data['user']['email'];

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        // Handle validation errors (422) or unauthorized (401)
        final errorData = jsonDecode(response.body);
        debugPrint("Update Failed: ${errorData['message']}");

        _setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint("Connection Error: $e");
      _setLoading(false);
      return false;
    }
  }

  /// Helper to handle loading state and UI refresh
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// Call this during Login to initialize the provider session
  void setUser(Map<String, dynamic> user, String token) {
    userId = user['id'];
    userName = user['name'] ?? "";
    userEmail = user['email'] ?? "";

    // Save token to ApiConfig for all subsequent requests
    ApiConfig.userToken = token;

    notifyListeners();
    debugPrint("User set: $userName (ID: $userId)");
  }

  /// Clear user data on Logout
  void clearUser() {
    userId = null;
    userName = "";
    userEmail = "";
    ApiConfig.userToken = null;
    notifyListeners();
  }

    /// Toggle user status logic
  Future<bool> toggleUserStatus(int id) async {
    _setLoading(true);
    
    // URL: http://.../api/users/{id}/toggle-status
    final url = Uri.parse("${ApiConfig.users}/$id/toggle-status");

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        _setLoading(false);
        // We notify listeners so the UI knows to rebuild with the new status
        notifyListeners(); 
        return true;
      } else {
        debugPrint("Toggle failed: ${response.body}");
        _setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint("Status Error: $e");
      _setLoading(false);
      return false;
    }
  }
  
}
