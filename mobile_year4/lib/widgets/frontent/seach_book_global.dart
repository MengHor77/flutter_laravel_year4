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

  @override
  ThemeData appBarTheme(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
      ),
      // FIX: Use dynamic background for the search scaffold
      scaffoldBackgroundColor: AppColors.getBackground(isDark),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textOnDark),
        border: InputBorder.none,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final results = items.where((book) {
      final queryLower = query.toLowerCase();
      return book.name.toLowerCase().contains(queryLower) ||
          (book.author ?? '').toLowerCase().contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return Container(
        // FIX: Use dynamic background
        color: AppColors.getBackground(isDark),
        child: Center(
          child: Text(
            "No results found.",
            // FIX: Use dynamic text color
            style: TextStyle(color: AppColors.getTextSecondary(isDark)),
          ),
        ),
      );
    }

    return Container(
      // FIX: Use dynamic background
      color: AppColors.getBackground(isDark),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final book = results[index];
          final bool isFreePdf = book.categoryName == "Free PDF";
          return BookCard(
            book: book,
            buttonText: isFreePdf ? "Download" : "Add to Cart",
            // FIX: Use dynamic success color
            buttonColor: AppColors.getSuccess(isDark),
            onAction: () {
              onAddToCart(book);
            },
          );
        },
      ),
    );
  }
}

/// Helper function updated for Dark Mode compatibility
void handleAddToCartGlobal(BuildContext context, Book book) async {
  final provider = context.read<BookProvider>();
  final messenger = ScaffoldMessenger.of(context);
  final bool isDark = Theme.of(context).brightness == Brightness.dark;

  FocusManager.instance.primaryFocus?.unfocus();

  messenger.removeCurrentSnackBar();
  messenger.clearSnackBars();

  if (ApiConfig.userToken == null) {
    messenger.showSnackBar(
      SnackBar(
        content: const Text("Please Login first!"),
        // FIX: Use dynamic danger color
        backgroundColor: AppColors.getDanger(isDark),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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
          // FIX: Use dynamic success color
          backgroundColor: AppColors.getSuccess(isDark),
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
      SnackBar(
        content: const Text("Error adding to cart"),
        // FIX: Custom dark-mode friendly warning or AppColors.warning
        backgroundColor: isDark ? Colors.orange.shade800 : AppColors.warning,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
