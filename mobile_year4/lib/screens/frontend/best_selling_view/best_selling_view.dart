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

class BestSellingView extends StatefulWidget {
  const BestSellingView({super.key});

  @override
  State<BestSellingView> createState() => _BestSellingViewState();
}

class _BestSellingViewState extends State<BestSellingView> {
  // Fetching data from Laravel API
  Future<List<dynamic>> _fetchBestSellers() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.bestSelling),
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load best sellers');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Best Selling'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(currentRoute: 'Best Selling'),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchBestSellers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No best sellers found."));
          }

          final items = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final bookData = items[index]['book'];
              final book = Book.fromJson(bookData);

              return BookCard(
                book: book,
                buttonText: "Add to Cart",
                buttonColor: AppColors.success,
                onAction: () {
                  // 1. ADD TO CART LOGIC
                  context.read<BookProvider>().addToCart(book);

                  // 2. SHOW SUCCESS MESSAGE
                  final messenger = ScaffoldMessenger.of(context);
                  messenger
                      .clearSnackBars(); // Clear queue before showing new one

                  messenger.showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1), // Standard duration
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${book.name} added successfully!",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                  // 3. THE 1-SECOND AUTO-CLOSE TIMER
                  // This forces the message to disappear exactly after 1 second
                  Timer(const Duration(seconds: 1), () {
                    messenger.hideCurrentSnackBar();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
