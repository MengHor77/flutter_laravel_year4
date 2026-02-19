import '../../../colors.dart';
import 'package:flutter/material.dart';

class OrderSearchDelegate extends SearchDelegate {
  final List orders;
  final String Function(String?) getImageUrl;

  OrderSearchDelegate({required this.orders, required this.getImageUrl});

  @override
  String get searchFieldLabel => "Search Book or Customer...";

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
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    // Filter by Book Name or User Name
    final results = orders.where((order) {
      final bookName = (order['book']?['name'] ?? "").toString().toLowerCase();
      final userName = (order['user']?['name'] ?? "").toString().toLowerCase();
      final input = query.toLowerCase();
      return bookName.contains(input) || userName.contains(input);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppColors.background,
        child: const Center(
          child: Text(
            "No matching orders found.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background, // Set the background color for the list area
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final order = results[index];
          final book = order['book'];
          final user = order['user'];
          double price = double.tryParse(order['price'].toString()) ?? 0.0;
          int qty = int.tryParse(order['quantity'].toString()) ?? 1;
          double total = price * qty;

          return Card(
            color: AppColors.cardBg, // Use your card background color
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: AppColors.lightGray, // Placeholder background
                  child: Image.network(
                    getImageUrl(book?['image']),
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, s) =>
                        const Icon(Icons.book, color: AppColors.textSecondary),
                  ),
                ),
              ),
              title: Text(
                book?['name'] ?? "Deleted Book",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer: ${user?['name'] ?? 'Guest'}",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  Text(
                    "Total: \$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color:
                          AppColors.success, // Using your success (green) color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                // Optional: Navigation logic
              },
            ),
          );
        },
      ),
    );
  }
}
