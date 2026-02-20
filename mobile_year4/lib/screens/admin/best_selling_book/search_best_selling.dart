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

  // ✅ ADDED: Internal Confirmation Dialog for Search
  Future<void> _confirmDelete(
    BuildContext context,
    int id,
    String bookName,
  ) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text("Confirm Delete"),
              content: Text(
                "Are you sure you want to remove '$bookName' from Best Sellers?",
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
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      onDelete(id);
      close(context, null); // Close search after confirmed delete
    }
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = bestSellingBooks.where((item) {
      final bookName = (item['book']?['name'] ?? "").toString().toLowerCase();
      return bookName.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppColors.background,
        child: const Center(
          child: Text(
            "No matching books found.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];
          final String bookName = item['book']?['name'] ?? "Unknown Book";

          return Card(
            color: AppColors.cardBg,
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.accent,
                child: Icon(Icons.star, color: Colors.white),
              ),
              title: Text(
                bookName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                "Price: \$${item['book']?['price'] ?? '0.00'}",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.warning),
                    onPressed: () {
                      close(context, null);
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
                      // ✅ UPDATED: Now calls the confirmation dialog
                      _confirmDelete(context, item['id'], bookName);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
