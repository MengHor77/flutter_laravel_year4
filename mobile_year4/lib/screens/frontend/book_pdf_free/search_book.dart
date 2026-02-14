import '../../../api_config.dart';
import 'package:flutter/material.dart';
import '../../../models/free_book_pdf_model.dart';

class BookSearchDelegate extends SearchDelegate {
  final List<FreeBookPdf> books;

  BookSearchDelegate(this.books);

  @override
  String get searchFieldLabel => 'Search name, author, or category';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    // Search logic: filters by Name, Author, or Category Name
    final results = books.where((book) {
      final searchLower = query.toLowerCase();
      return book.name.toLowerCase().contains(searchLower) ||
          book.author.toLowerCase().contains(searchLower) ||
          book.categoryName.toLowerCase().contains(searchLower);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No books found matching your search."));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        final imageUrl = "${ApiConfig.baseUrl}/storage/${book.image}";

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.book),
            ),
          ),
          title: Text(book.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("${book.author} • ${book.categoryName}"),
          onTap: () {
            // Add your navigation to Read or Detail view here
            close(context, null);
          },
        );
      },
    );
  }
}