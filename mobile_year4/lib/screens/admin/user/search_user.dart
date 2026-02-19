import '../../../colors.dart';
import 'package:flutter/material.dart';

class UserSearchDelegate extends SearchDelegate {
  final List<dynamic> users;

  UserSearchDelegate({required this.users});

  @override
  String get searchFieldLabel => "Search by name or email...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final results = users.where((user) {
      final name = (user['name'] ?? "").toString().toLowerCase();
      final email = (user['email'] ?? "").toString().toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input) || email.contains(input);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No users match your search."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final user = results[index];
        return Card(
          color: AppColors.cardBg,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.accent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              user['name'] ?? "No Name",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user['email'] ?? "No Email"),
          ),
        );
      },
    );
  }
}
