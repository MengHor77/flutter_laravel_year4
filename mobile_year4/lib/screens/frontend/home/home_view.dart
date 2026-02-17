import 'dart:async';
import 'dart:convert';
import '../../../../colors.dart';
import '../../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../models/book_model.dart';
import 'package:mobile_year4/screens/frontend/home/book_cart.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // ✅ រក្សាកូដ Logic ដើមសម្រាប់ទាញទិន្នន័យពី API
  Future<List<Book>> _fetchBestSellers() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.bestSelling),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // ✅ ប្តូរការ Map ទិន្នន័យឱ្យត្រូវជាមួយ Response របស់ Laravel
        return data.map((item) => Book.fromJson(item['book'])).toList();
      }
      throw Exception('Failed to load books');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ លុប Scaffold, AppBar និង Drawer ចេញ ដើម្បីឱ្យវាបង្ហាញ Bottom Nav របស់ MainWrapper
    return SingleChildScrollView(
      // ✅ បន្ថែម RefreshIndicator ដើម្បីឱ្យ User អាចអូសចុះក្រោមដើម្បី Update ទិន្នន័យ
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ឱ្យអក្សរនៅកៀនឆ្វេង
          children: [
            const Text(
              'Best Selling Books',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Book>>(
              future: _fetchBestSellers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text("Connection Error: សូមពិនិត្យមើល Server Laravel របស់អ្នក"),
                    ),
                  );
                }

                final books = snapshot.data ?? [];

                if (books.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text("No books found.")),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    // ✅ បញ្ជូនទិន្នន័យទៅ BookCard
                    return BookCard(book: books[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}