import 'dart:convert';
import '../../../../colors.dart';
import '../../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async'; // Required for Timer
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Book Store"),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnDark,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppSidebar(currentRoute: 'Books'),
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
      onAction: () async {
        // 1. Check if logged in before calling provider
        if (ApiConfig.userToken == null) {
          final snack = ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please Login first to add items!"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );

          // Example of using Timer to close the message manually
          Timer(const Duration(seconds: 3), () {
            snack.close();
          });
          return;
        }

        // 2. Call provider to sync with MySQL
        await context.read<BookProvider>().addToCart(book);

        // 3. UI Feedback
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();

        messenger.showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2), // Auto-close after 2 seconds
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${book.name} have added to order list!",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: "VIEW",
              textColor: Colors.white,
              onPressed: () {
                messenger.hideCurrentSnackBar();
                Navigator.pushNamed(context, '/order-list');
              },
            ),
          ),
        );

        // Optional: Using Timer to ensure the SnackBar is hidden after a set period
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            messenger.hideCurrentSnackBar();
          }
        });
      },
    );
  }
}
