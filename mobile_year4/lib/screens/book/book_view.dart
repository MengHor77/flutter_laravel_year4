import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../models/book_model.dart';
import 'dart:async'; // Required for Timer
import '../../../providers/book_provider.dart';
import '../../../widgets/frontent/book_card.dart';
import '../../../widgets/frontent/menu_sidebar.dart';

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
      debugPrint("Error: $e");
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
        backgroundColor: AppColors.primary,
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
          : ListView.builder(
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
      onAction: () {
        // 1. Logic: Add to cart
        context.read<BookProvider>().addToCart(book);

        // 2. Prepare Messenger
        final messenger = ScaffoldMessenger.of(context);
        messenger
            .clearSnackBars(); // Instantly remove any currently showing snacks

        // 3. Show Success SnackBar
        messenger.showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success, // Changed to success green
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${book.name} added successfully!",
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

        // 4. FORCE CLOSE TIMER (1 Second)
        // This ensures the snackbar is removed exactly after 1 second
        Timer(const Duration(seconds: 1), () {
          messenger.hideCurrentSnackBar();
        });
      },
    );
  }
}
