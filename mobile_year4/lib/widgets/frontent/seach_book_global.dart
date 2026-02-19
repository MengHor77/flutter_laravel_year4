import '../../colors.dart';
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
      IconButton(
        icon: const Icon(Icons.clear), 
        onPressed: () => query = '',
      ),
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
            // Trigger the global helper function
            onAddToCart(book);
          },
        );
      },
    );
  }
}

/// Helper function to handle adding to cart from Search or anywhere else
/// This ensures the SnackBar and Navigation work together.
void handleAddToCartGlobal(BuildContext context, Book book) async {
  final provider = context.read<BookProvider>();
  final messenger = ScaffoldMessenger.of(context);

  // 1. Add to cart via Provider
  await provider.addToCart(book);

  // 2. Clear old SnackBars and show the success one
  messenger.clearSnackBars();
  
  messenger.showSnackBar(
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
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "VIEW",
        textColor: Colors.white,
        onPressed: () {
          // Force close the snackbar immediately
          messenger.clearSnackBars();
          
          // Switch to Order List Tab (Index 2)
          if (provider.onOrderSuccess != null) {
            provider.onOrderSuccess!(2);
          }
        },
      ),
    ),
  );
}