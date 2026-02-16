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

  @override
  Widget build(BuildContext context) {
    return _isLoading
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
          );
  }

  Widget _buildCard(int index) {
    final book = _books[index];
    return BookCard(
      book: book,
      buttonText: "Add to Cart",
      buttonColor: AppColors.success,
      onAction: () async {
        // 1. Check if user is logged in
        if (ApiConfig.userToken == null) {
          // Clear any existing snackbars immediately so this one shows up and starts its 2s timer
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

        // 2. Clear snackbars before starting the "Add to Cart" process
        // This prevents the user from seeing a "ghost" snackbar while waiting for the API
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();

        try {
          // 3. Perform the logic
          await context.read<BookProvider>().addToCart(book);

          // 4. Check if the widget is still in the tree
          if (!mounted) return;

          // 5. Show Success SnackBar
          messenger.showSnackBar(
            SnackBar(
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2), // Fixed 2-second timeout
              persist: false,
              content: Text("${book.name} added to cart!"),
              action: SnackBarAction(
                label: "VIEW",
                textColor: Colors.white,
                onPressed: () {
                  // Hide immediately when clicking the action button
                  messenger.hideCurrentSnackBar();
                  // Update MainWrapper index to 2 (Order List)
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
      },
    );
  }
}
