import 'dart:async';
import 'dart:convert';
import '../../../../colors.dart';
import '../../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../models/book_model.dart';
import '../../../../providers/book_provider.dart';
import '../../../../widgets/frontent/book_card.dart';
import '../../../../widgets/frontent/seach_book_global.dart'; // ✅ Import the global helper

class BookView extends StatefulWidget {
  const BookView({super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.books),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> rawData = jsonDecode(response.body);
        final loadedBooks = rawData.map((json) => Book.fromJson(json)).toList();

        if (mounted) {
          context.read<BookProvider>().setBooks(loadedBooks);
        }
      }
    } catch (e) {
      debugPrint("Error fetching books: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BookProvider>().books;

    // ✅ Removed Scaffold to prevent "Snackbar Trapping"
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchBooks,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (ctx, index) {
          final book = books[index];
          return BookCard(
            book: book,
            buttonText: "Add to Cart",
            buttonColor: AppColors.success,
            onAction: () => handleAddToCartGlobal(context, book), // ✅ Uses Global
          );
        },
      ),
    );
  }
}