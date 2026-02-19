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

  /// STYLING: Applies AppColors.primary to the search bar area
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

  Widget _buildSearchResults(BuildContext context) {
    // Filter based on item['book']['name']
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
                item['book']?['name'] ?? "Unknown Book",
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
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.warning,
                    ), // Changed to warning for consistency
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
      ),
    );
  }
}
