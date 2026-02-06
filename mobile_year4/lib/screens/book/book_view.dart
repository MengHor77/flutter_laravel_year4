import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/frontent/book_card.dart';
import '../../../widgets/frontent/menu_sidebar.dart';
import '../../../models/book_model.dart'; // 1. Imported your model

class BookView extends StatefulWidget {
  const BookView({super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  // 2. Specify the list type as Book to prevent type errors
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
      final response = await http.get(Uri.parse(ApiConfig.books));
      
      if (response.statusCode == 200) {
        final List<dynamic> rawData = jsonDecode(response.body);
        
        setState(() {
          // 3. Convert Map items into Book objects using your model's factory
          _books = rawData.map((json) => Book.fromJson(json)).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching books: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load books from server"),
            backgroundColor: AppColors.danger,
          ),
        );
      }
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
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : RefreshIndicator(
              onRefresh: _fetchBooks,
              color: AppColors.accent,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_books.isEmpty) {
                    return const Center(
                      child: Text("No books available at the moment."),
                    );
                  }

                  // Responsive Grid for Tablets/Desktop
                  if (constraints.maxWidth > 600) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _books.length,
                      itemBuilder: (ctx, index) => _buildCard(index),
                    );
                  }

                  // Standard List for Mobile
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _books.length,
                    itemBuilder: (ctx, index) => _buildCard(index),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildCard(int index) {
    final book = _books[index];
    
    return BookCard(
      book: book, // Now this is a 'Book' type, not a Map
      buttonText: "Add to Cart",
      buttonColor: AppColors.success,
      onAction: () {
        // Since it's a Book object, use dot notation (book.name)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            content: Text("${book.name} added to Order List!"),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: "VIEW CART",
              textColor: AppColors.accent,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        );
      },
    );
  }
}