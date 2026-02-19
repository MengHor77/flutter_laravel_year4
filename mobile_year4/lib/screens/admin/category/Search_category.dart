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
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.textOnDark),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    final results = categories.where((cat) {
      final name = cat['name'].toString().toLowerCase();
      final description = (cat['description'] ?? '').toString().toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input) || description.contains(input);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppColors.background,
        child: const Center(
          child: Text(
            "No categories match your search.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final cat = results[index];
          return Card(
            color: AppColors.cardBg,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              title: Text(
                cat['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                cat['description'] ?? '',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.warning),
                    onPressed: () {
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
                      close(context, null);
                      confirmDelete(cat['id'], cat['name']);
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
