import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // គណនាចំនួនសារមិនទាន់អាន
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // ១. ទាញយកទិន្នន័យ
  Future<void> fetchNotifications() async {
    if (_isLoading) return;

    _isLoading = true;
    // ការពារ Error "setState() or markNeedsBuild() called during build"
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    try {
      final response = await NotificationService.fetchAll();

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _notifications = data
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        debugPrint("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Notification Fetch Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ២. កំណត់ថាអានរួច
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);

    if (index != -1 && !_notifications[index].isRead) {
      // ប្តូរក្នុង UI ភ្លាមៗ (Optimistic Update)
      _notifications[index].isRead = true;
      notifyListeners();

      try {
        // បាញ់ទៅ Laravel
        final response = await NotificationService.markAsRead(id);

        if (response.statusCode != 200) {
          // ប្រសិនបើ Server បដិសេធ យើងប្តូរមក Unread វិញដើម្បីឱ្យ User ដឹង
          _notifications[index].isRead = false;
          notifyListeners();
          debugPrint("Failed to sync with server: ${response.body}");
        }
      } catch (e) {
        // បើ Error Network ក៏ប្តូរមកវិញដែរ
        _notifications[index].isRead = false;
        notifyListeners();
        debugPrint("MarkAsRead Error: $e");
      }
    }
  }

  void clearLocalNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
