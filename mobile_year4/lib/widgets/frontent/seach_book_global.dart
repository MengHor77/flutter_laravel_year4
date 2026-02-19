import '../../colors.dart';
import '../../models/book_model.dart';
import 'package:flutter/material.dart';
import '../../widgets/frontent/book_card.dart';
import '../../screens/frontend/book/book_view.dart';

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
            // Close search and trigger the force-close snackbar logic
            handleAddToCartGlobal(context, book);
          },
        );
      },
    );
  }
}
