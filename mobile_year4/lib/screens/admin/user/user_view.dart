import 'dart:convert';
import 'search_user.dart';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserView extends StatefulWidget {
  final VoidCallback openDrawer;
  const UserView({super.key, required this.openDrawer});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<dynamic> _allUsers = [];

  Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.users),
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _allUsers = data;
        return data;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ✅ NEW: Logic to Toggle User Status (Active/Inactive)
  Future<void> _toggleUserStatus(Map user) async {
    final int userId = user['id'];
    final bool currentlyActive =
        user['is_active'] == 1 || user['is_active'] == true;
    final String newStatusAction = currentlyActive ? "Deactivate" : "Activate";

    // Show confirmation dialog
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.cardBg,
            title: Text(
              "$newStatusAction User",
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            content: Text(
              "Are you sure you want to $newStatusAction ${user['name']}?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentlyActive
                      ? AppColors.danger
                      : AppColors.success,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  newStatusAction,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      try {
        // Replace with your actual status toggle endpoint
        final response = await http.post(
          Uri.parse("${ApiConfig.users}/$userId/toggle-status"),
          headers: ApiConfig.getHeaders(),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "User $newStatusAction"
                "d successfully",
              ),
              backgroundColor: AppColors.success,
            ),
          );
          setState(() {}); // Refresh the FutureBuilder
        }
      } catch (e) {
        debugPrint("Status toggle error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearchDelegate(users: _allUsers),
              ).then(
                (_) => setState(() {}),
              ); // Refresh when coming back from search
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          final users = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              // Check status (adjust key 'is_active' based on your API)
              final bool isActive =
                  user['is_active'] == 1 || user['is_active'] == true;

              return Card(
                color: AppColors.cardBg,
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isActive
                        ? AppColors.success
                        : AppColors.textHint,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    user['name'] ?? "No Name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user['email'] ?? "No Email"),
                  // ✅ CHANGED: Delete button replaced with Active/Inactive toggle
                  trailing: TextButton.icon(
                    onPressed: () => _toggleUserStatus(user),
                    icon: Icon(
                      isActive ? Icons.check_circle : Icons.pause_circle_filled,
                      color: isActive ? AppColors.success : AppColors.danger,
                      size: 20,
                    ),
                    label: Text(
                      isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        color: isActive ? AppColors.success : AppColors.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
