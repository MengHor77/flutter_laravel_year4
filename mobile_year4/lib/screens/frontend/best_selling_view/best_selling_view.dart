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

class BestSellingView extends StatefulWidget {
  const BestSellingView({super.key});

  @override
  State<BestSellingView> createState() => _BestSellingViewState();
}

class _BestSellingViewState extends State<BestSellingView> {
  Future<List<dynamic>>? _bestSellerFuture;

  @override
  void initState() {
    super.initState();
    _bestSellerFuture = _fetchBestSellers();
  }

  Future<List<dynamic>> _fetchBestSellers() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.bestSelling),
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (mounted) {
          final List<Book> books = (data as List)
              .map((item) => Book.fromJson(item['book'] ?? item))
              .toList();
          context.read<BookProvider>().setBestSellers(books);
        }
        return data;
      } else {
        throw Exception('Failed to load best sellers');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _bestSellerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final items = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final bookData = items[index]['book'] ?? items[index];
            final book = Book.fromJson(bookData);

            return BookCard(
              book: book,
              buttonText: "Add to Cart",
              buttonColor: AppColors.success,
              onAction: () => handleAddToCartGlobal(context, book), // ✅ Uses Global
            );
          },
        );
      },
    );
  }
}