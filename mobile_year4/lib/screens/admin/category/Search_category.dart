import 'edit_category.dart';
import '../../../colors.dart';
import 'package:flutter/material.dart';

class CategorySearchDelegate extends SearchDelegate {
  final List categories;
  final Function fetchCategories;
  final Function(int, String) confirmDelete;

  CategorySearchDelegate({
    required this.categories,
    required this.fetchCategories,
    required this.confirmDelete,
  });

  @override
  String get searchFieldLabel => "Search categories...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search query
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    // Filter categories based on query
    final results = categories.where((cat) {
      final name = cat['name'].toString().toLowerCase();
      final description = (cat['description'] ?? '').toString().toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input) || description.contains(input);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No categories match your search."));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final cat = results[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            title: Text(
              cat['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(cat['description'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.warning),
                  onPressed: () {
                    // Close search then open edit dialog
                    close(context, null);
                    showDialog(
                      context: context,
                      builder: (context) => EditCategory(
                        category: cat,
                        onRefresh: () => fetchCategories(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.danger),
                  onPressed: () {
                    // Close search then show confirm delete
                    close(context, null);
                    confirmDelete(cat['id'], cat['name']);
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