import 'dart:async';
import '../../colors.dart';
import '../../api_config.dart';
import '../../models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../widgets/frontent/book_card.dart';

class GlobalBookSearchDelegate extends SearchDelegate {
  final List<Book> items;
  final Function(Book) onAddToCart;
  final String hintText;

  GlobalBookSearchDelegate({
    required this.items,
    required this.onAddToCart,
    this.hintText = 'Search name or author...',
  });

  @override
  String get searchFieldLabel => hintText;

  /// STYLING: Applies AppColors.primary (Navy) to the search bar
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textOnDark),
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
    final results = items.where((book) {
      final queryLower = query.toLowerCase();
      return book.name.toLowerCase().contains(queryLower) ||
          (book.author ?? '').toLowerCase().contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppColors.background,
        child: const Center(
          child: Text(
            "No results found.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final book = results[index];
          final bool isFreePdf = book.categoryName == "Free PDF";
           return BookCard(
            book: book,
            buttonText: isFreePdf ? "Download" : "Add to Cart",
            buttonColor: AppColors.success, // Already using AppColors
            onAction: () {
              onAddToCart(book);
            },
          );
        },
      ),
    );
  }
}

/// Helper function with updated AppColors for SnackBars
void handleAddToCartGlobal(BuildContext context, Book book) async {
  final provider = context.read<BookProvider>();
  final messenger = ScaffoldMessenger.of(context);

  FocusManager.instance.primaryFocus?.unfocus();

  messenger.removeCurrentSnackBar();
  messenger.clearSnackBars();

  // Auth Check
  if (ApiConfig.userToken == null) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text("Please Login first!"),
        backgroundColor: AppColors.danger, // Using your red color
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  try {
    await provider.addToCart(book);

    if (context.mounted) {
      final snackBarController = messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.textOnDark,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${book.name} added to cart!",
                  style: const TextStyle(color: AppColors.textOnDark),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success, // Using your green color
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "VIEW",
            textColor: AppColors.textOnDark,
            onPressed: () {
              messenger.removeCurrentSnackBar();
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              if (provider.onOrderSuccess != null) {
                provider.onOrderSuccess!(2);
              }
            },
          ),
        ),
      );

      Timer(const Duration(seconds: 2), () {
        try {
          snackBarController.close();
        } catch (e) {}
      });
    }
  } catch (e) {
    debugPrint("DEBUG: ERROR: $e");
    messenger.showSnackBar(
      const SnackBar(
        content: Text("Error adding to cart"),
        backgroundColor: AppColors.warning, // Using your orange color
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
