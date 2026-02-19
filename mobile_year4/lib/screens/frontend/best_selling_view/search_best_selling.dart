import '../../../../colors.dart';
import 'package:flutter/material.dart';
import '../../../../models/book_model.dart';
import '../../../../widgets/frontent/book_card.dart';

class BestSellingSearchDelegate extends SearchDelegate {
  final List<dynamic> items;
  final Function(Book) onAddToCart;

  BestSellingSearchDelegate({required this.items, required this.onAddToCart});

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
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    // Logic to filter the best selling items
    final results = items.where((item) {
      final bookData = item['book'];
      final name = (bookData['name'] ?? '').toString().toLowerCase();
      final author = (bookData['author'] ?? '').toString().toLowerCase();
      final price = (bookData['price'] ?? '').toString().toLowerCase();
      final search = query.toLowerCase();

      return name.contains(search) ||
          author.contains(search) ||
          price.contains(search);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No best sellers match your search."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = Book.fromJson(results[index]['book']);
        return BookCard(
          book: book,
          buttonText: "Add to Cart",
          buttonColor: AppColors.success,
          onAction: () {
            onAddToCart(book);
            close(context, null); // Close search overlay
          },
        );
      },
    );
  }
}
