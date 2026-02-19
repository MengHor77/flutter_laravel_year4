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

  /// STYLING: Applies AppColors.primary to the search bar area
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
      ),
      // Styling the text input field
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textHint),
        border: InputBorder.none,
      ),
      // Styling the cursor and text color
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
    final results = books.where((book) {
      final queryLower = query.toLowerCase();
      return book.name.toLowerCase().contains(queryLower) ||
          book.author.toLowerCase().contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppColors.background,
        child: const Center(
          child: Text(
            "No books found.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background, // Use global background color
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final book = results[index];
          return Card(
            color: AppColors.cardBg, 
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 40,
                  height: 60,
                  color: AppColors.lightGray,
                  child: Image.network(
                    getImageUrl(book.image),
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => const Icon(
                      Icons.broken_image,
                      color: AppColors.textSecondary,
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
                book.author,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.warning),
                    onPressed: () {
                      close(context, null);
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
                      close(context, null);
                      onDelete(book);
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
