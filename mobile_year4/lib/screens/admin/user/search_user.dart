import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserSearchDelegate extends SearchDelegate {
  final List<dynamic> users;

  UserSearchDelegate({required this.users});

  @override
  String get searchFieldLabel => "Search by name or email...";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textHint),
        border: InputBorder.none,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.accent,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColors.textOnDark, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: AppColors.textOnDark),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.textOnDark),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  // --- Logic to toggle status with Confirmation Dialog ---
  Future<void> _toggleUserStatus(BuildContext context, Map user) async {
    final bool isActive = user['is_active'] == 1 || user['is_active'] == true;
    final String action = isActive ? "Deactivate" : "Activate";

    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.cardBg,
            title: Text(
              "$action User",
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            content: Text("Are you sure you want to $action ${user['name']}?"),
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
                  backgroundColor: isActive
                      ? AppColors.danger
                      : AppColors.success,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  action,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      try {
        final response = await http.post(
          Uri.parse("${ApiConfig.users}/${user['id']}/toggle-status"),
          headers: ApiConfig.getHeaders(),
        );

        if (response.statusCode == 200) {
          // Close the search after a successful update so the main view refreshes
          close(context, null);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User ${action}d successfully"),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        debugPrint("Toggle Error: $e");
      }
    }
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = users.where((user) {
      final name = (user['name'] ?? "").toString().toLowerCase();
      final email = (user['email'] ?? "").toString().toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input) || email.contains(input);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppColors.background,
        child: const Center(
          child: Text(
            "No users match your search.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final user = results[index];
          final bool isActive =
              user['is_active'] == 1 || user['is_active'] == true;

          return Card(
            color: AppColors.cardBg,
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isActive
                    ? AppColors.success
                    : AppColors.textHint,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                user['name'] ?? "No Name",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                user['email'] ?? "No Email",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              // ✅ Updated Trailing: Status Button
              trailing: InkWell(
                onTap: () => _toggleUserStatus(context, user),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive ? AppColors.success : AppColors.danger,
                    ),
                  ),
                  child: Text(
                    isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      color: isActive ? AppColors.success : AppColors.danger,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
