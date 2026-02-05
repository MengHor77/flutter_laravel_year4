import '../../widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/menu_sidebar.dart';
import '../../providers/book_provider.dart';

class BookView extends StatelessWidget {
  const BookView({super.key});

  @override
  Widget build(BuildContext context) {
    // Listens for changes in the BookProvider
    final provider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
        // ADD THESE TWO LINES FOR THE BLUE BACKGROUND
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

        // Builder allows the button to find the Scaffold and open the drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // The "==" hamburger icon
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppSidebar(currentRoute: 'Books'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: provider.books.length,
              itemBuilder: (ctx, index) => _buildCard(context, provider, index),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.books.length,
            itemBuilder: (ctx, index) => _buildCard(context, provider, index),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, BookProvider provider, int index) {
    final book = provider.books[index];
    return BookCard(
      book: book,
      buttonText: "Add to Cart",
      buttonColor: Colors.green,
      onAction: () {
        // Adds the book to the global cart list
        context.read<BookProvider>().addToCart(book);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${book.title} added to Order List!"),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: "VIEW CART",
              onPressed: () {
                // Quick navigation to the order list from snackbar
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        );
      },
    );
  }
}
