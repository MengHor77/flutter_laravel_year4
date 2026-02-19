import '../../../colors.dart';
import 'edit_best_selling.dart';
import 'package:flutter/material.dart';

class BestSellingSearchDelegate extends SearchDelegate {
  final List<dynamic> bestSellingBooks;
  final Function(int) onDelete;
  final VoidCallback onRefresh;

  BestSellingSearchDelegate({
    required this.bestSellingBooks,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  String get searchFieldLabel => "Search by book name...";

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
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    // Filter based on item['book']['name']
    final results = bestSellingBooks.where((item) {
      final bookName = (item['book']?['name'] ?? "").toString().toLowerCase();
      return bookName.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No matching books found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.accent,
              child: Icon(Icons.star, color: Colors.white),
            ),
            title: Text(item['book']?['name'] ?? "Unknown Book"),
            subtitle: Text("Price: \$${item['book']?['price'] ?? '0.00'}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    close(context, null); // Close search before navigating
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditBestSelling(item: item),
                      ),
                    ).then((_) => onRefresh());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.danger),
                  onPressed: () {
                    onDelete(item['id']);
                    close(context, null); // Close search after delete
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
