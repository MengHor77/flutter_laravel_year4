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
    final results = items.where((book) {
      final queryLower = query.toLowerCase();
      return book.name.toLowerCase().contains(queryLower) ||
          (book.author ?? '').toLowerCase().contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No results found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return BookCard(
          book: book,
          buttonText: "Add to Cart",
          buttonColor: AppColors.success,
          onAction: () {
            // This calls the helper function below
            onAddToCart(book);
          },
        );
      },
    );
  }
}

void handleAddToCartGlobal(BuildContext context, Book book) async {
  final provider = context.read<BookProvider>();
  final messenger = ScaffoldMessenger.of(context);

  // Unfocus keyboard if search is open
  FocusManager.instance.primaryFocus?.unfocus();

  // Clear any existing snackbars immediately
  messenger.removeCurrentSnackBar();
  messenger.clearSnackBars();

  // Auth Check
  if (ApiConfig.userToken == null) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text("Please Login first!"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  try {
    // Add to cart via Provider
    await provider.addToCart(book);

    if (context.mounted) {
      // 2. Capture the controller into a variable
      final snackBarController = messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${book.name} added to cart!",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2), // Standard duration
          action: SnackBarAction(
            label: "VIEW",
            textColor: Colors.white,
            onPressed: () {
              // ✅ INSTANTLY kill the snackbar
              messenger.removeCurrentSnackBar();

              // ✅ CLOSE SEARCH: If the search overlay is open, close it
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }

              // ✅ NAVIGATE: Switch to the Order List tab
              if (provider.onOrderSuccess != null) {
                provider.onOrderSuccess!(2);
              }
            },
          ),
        ),
      );

      // 3. ✅ FORCE CLOSE TIMER
      // This solves the issue where SnackBars with buttons stay open forever
      Timer(const Duration(seconds: 2), () {
        try {
          snackBarController.close();
        } catch (e) {
          // If the user already clicked "VIEW" or swiped it away, ignore the error
        }
      });
    }
  } catch (e) {
    debugPrint("DEBUG: ERROR: $e");
    messenger.showSnackBar(
      const SnackBar(
        content: Text("Error adding to cart"),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
