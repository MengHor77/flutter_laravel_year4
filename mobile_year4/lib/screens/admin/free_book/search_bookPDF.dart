import '../../../colors.dart';
import 'edit_free_book_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/free_book_pdf_provider.dart';

class BookPDFSearchDelegate extends SearchDelegate {
  final String Function(String?) getImageUrl;
  final Function(String) onDelete;

  BookPDFSearchDelegate({required this.getImageUrl, required this.onDelete});

  @override
  String get searchFieldLabel => "Search by name or author...";

  // Style the search bar to match your AppBar theme
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textHint),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColors.textOnDark),
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
    final provider = Provider.of<FreeBookPdfProvider>(context, listen: false);

    final results = provider.freeBooks.where((book) {
      final name = book.name.toLowerCase();
      final author = book.author.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input) || author.contains(input);
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          "No PDFs found matching your search.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final book = results[index];
          final String imageUrl = getImageUrl(book.image);

          return Card(
            color: AppColors.cardBg,
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  imageUrl,
                  width: 50,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 50,
                    height: 70,
                    color: AppColors.lightGray,
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ),
              title: Text(
                book.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                "Author: ${book.author}",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.accent),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => EditFreeBookView(book: book),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.danger),
                    onPressed: () {
                      close(context, null);
                      onDelete(book.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
