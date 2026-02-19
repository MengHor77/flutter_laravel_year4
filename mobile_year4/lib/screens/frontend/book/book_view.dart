import 'dart:async';
import 'dart:convert';
import 'search_book.dart';
import '../../../../colors.dart';
import '../../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../models/book_model.dart';
import '../../../../providers/book_provider.dart';
import '../../../../widgets/frontent/book_card.dart';
import '../../../../widgets/frontent/menu_sidebar.dart';

class BookView extends StatefulWidget {
  const BookView({super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  List<Book> _books = [];
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
        setState(() {
          _books = rawData.map((json) => Book.fromJson(json)).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching books: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ Keep your exact logic but made reusable for Search
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(
                  books: _books,
                  onAddToCart: _handleAddToCart,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : RefreshIndicator(
              onRefresh: _fetchBooks,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _books.length,
                itemBuilder: (ctx, index) => _buildCard(index),
              ),
            ),
    );
  }

  Widget _buildCard(int index) {
    final book = _books[index];
    return BookCard(
      book: book,
      buttonText: "Add to Cart",
      buttonColor: AppColors.success,
      onAction: () => _handleAddToCart(book), // ✅ Using the shared logic
    );
  }

  Future<void> _handleAddToCart(Book book) async {
    // 1. Check if user is logged in
    if (ApiConfig.userToken == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Login first!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      // 3. Perform the logic
      await context.read<BookProvider>().addToCart(book);

      if (!mounted) return;

      // 5. Show Success SnackBar
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          content: Text("${book.name} added to cart!"),
          action: SnackBarAction(
            label: "VIEW",
            textColor: Colors.white,
            onPressed: () {
              messenger.hideCurrentSnackBar();
              context.read<BookProvider>().onOrderSuccess?.call(2);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text("Failed to add to cart: $e"),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
