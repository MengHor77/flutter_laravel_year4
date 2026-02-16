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

class BestSellingView extends StatefulWidget {
  const BestSellingView({super.key});

  @override
  State<BestSellingView> createState() => _BestSellingViewState();
}

class _BestSellingViewState extends State<BestSellingView> {
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
    // បោះចេញតែ content មិនប្រើ Scaffold ទេ
    return FutureBuilder<List<dynamic>>(
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
              onAction: () async {
                await context.read<BookProvider>().addToCart(book);

                final messenger = ScaffoldMessenger.of(context);
                messenger.clearSnackBars();

                messenger.showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    content: Text("${book.name} added successfully!"),
                    action: SnackBarAction(
                      label: "VIEW",
                      textColor: Colors.white,
                      onPressed: () => Navigator.pushNamed(context, '/order-list'),
                    ),
                  ),
                );

                Timer(const Duration(seconds: 2), () {
                  if (mounted) messenger.hideCurrentSnackBar();
                });
              },
            );
          },
        );
      },
    );
  }
}