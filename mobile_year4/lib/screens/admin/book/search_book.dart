import 'edit_book.dart';
import '../../../colors.dart';
import 'package:flutter/material.dart';
import '../../../models/book_model.dart';

class BookSearchDelegate extends SearchDelegate {
  final List<Book> books;
  final Function onRefresh;
  final Function(Book) onDelete;
  final String Function(String?) getImageUrl;

  BookSearchDelegate({
    required this.books,
    required this.onRefresh,
    required this.onDelete,
    required this.getImageUrl,
  });

  @override
  String get searchFieldLabel => "Search by title or author...";

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
    final results = books.where((book) {
      final queryLower = query.toLowerCase();
      return book.name.toLowerCase().contains(queryLower) ||
          book.author.toLowerCase().contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No books found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return Card(
          color: AppColors.cardBg,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                getImageUrl(book.image),
                width: 40,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.book),
              ),
            ),
            title: Text(
              book.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(book.author),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.warning),
                  onPressed: () {
                    close(context, null); // Close search overlay
                    showDialog(
                      context: context,
                      builder: (ctx) =>
                          EditBook(book: book, onRefresh: () => onRefresh()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.danger),
                  onPressed: () {
                    close(context, null); // Close search overlay
                    onDelete(book);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
