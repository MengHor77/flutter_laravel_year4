import 'sale_detail.dart';
import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart';

class SaleSearchDelegate extends SearchDelegate {
  final List<dynamic> saleDetails;

  SaleSearchDelegate({required this.saleDetails});

  @override
  String get searchFieldLabel => "Search Book or Customer...";

  /// STYLING: Applying your AppColors.primary (Navy) to the search bar
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
    // Filter sales based on Book Name or User Name
    final results = saleDetails.where((sale) {
      final bookName = (sale['book']?['name'] ?? "").toString().toLowerCase();
      final userName = (sale['user']?['name'] ?? "").toString().toLowerCase();
      final input = query.toLowerCase();
      return bookName.contains(input) || userName.contains(input);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppColors.background, // Maintain consistent background
        child: const Center(
          child: Text(
            "No matching transactions found.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background, // Match dashboard background
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final sale = results[index];
          // Reuse your existing SaleDetailItem widget
          return SaleDetailItem(sale: sale);
        },
      ),
    );
  }
}
