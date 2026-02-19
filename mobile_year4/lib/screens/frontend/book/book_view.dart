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
          // ✅ SYNC WITH PROVIDER: This makes the search work in MainLayout
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : RefreshIndicator(
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
                    onAction: () => handleAddToCartGlobal(context, book),
                  );
                },
              ),
            ),
    );
  }
}

Future<void> handleAddToCartGlobal(BuildContext context, Book book) async {
  final provider = context.read<BookProvider>();
  final messenger = ScaffoldMessenger.of(context);

  FocusManager.instance.primaryFocus?.unfocus();

  // Clear any existing one immediately
  messenger.clearSnackBars();

  if (ApiConfig.userToken == null) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text("Please Login first!"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  try {
    await provider.addToCart(book);

    // 1. Capture the controller
    final controller = messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        // Force the duration to be respected even with an action
        dismissDirection: DismissDirection.horizontal,
        content: Text("${book.name} added to cart!"),
        action: SnackBarAction(
          label: "VIEW",
          textColor: Colors.white,
          onPressed: () {
            messenger.hideCurrentSnackBar();
            provider.onOrderSuccess?.call(2);
          },
        ),
      ),
    );

    // 2. FORCE CLOSE TIMER (Workaround for Material 3 ignore-duration bug)
    // This ensures that even if Material 3 tries to keep it open, it dies in 2s.
    Timer(const Duration(seconds: 2), () {
      try {
        controller.close();
      } catch (e) {
        // Already closed, ignore
      }
    });

    controller.closed.then((reason) {
      debugPrint("DEBUG: SnackBar closed via: $reason");
    });
  } catch (e) {
    debugPrint("DEBUG: ERROR: $e");
    messenger.showSnackBar(
      const SnackBar(
        content: Text("Error adding to cart"),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
