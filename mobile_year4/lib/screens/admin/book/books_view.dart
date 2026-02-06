import 'dart:convert';
import 'edit_book.dart';
import 'create_book.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../colors.dart'; // 1. Import your color config

class ManageBooksView extends StatefulWidget {
  final VoidCallback openDrawer;
  const ManageBooksView({super.key, required this.openDrawer});

  @override
  State<ManageBooksView> createState() => _ManageBooksViewState();
}

class _ManageBooksViewState extends State<ManageBooksView> {
  List _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(ApiConfig.books));
      if (response.statusCode == 200) {
        setState(() => _books = jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteBook(int id) async {
    try {
      final response = await http.delete(Uri.parse("${ApiConfig.books}/$id"));
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Book deleted successfully!"),
              backgroundColor: AppColors.danger, // Use Danger color (Red)
            ),
          );
        }
        _fetchBooks();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Use Background color (Grey[100])
      appBar: AppBar(
        title: const Text("Manage Books"),
        backgroundColor: AppColors.primary, // Use Primary color (BlueGrey[900])
        foregroundColor: AppColors.textOnDark, // Use Text on Dark (White)
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return Card(
                  color: AppColors.cardBg, // Use Card Background (White)
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.book, color: AppColors.accent), // Use Accent (Blue)
                    title: Text(
                      book['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      "${book['author']} | ${book['category']['name']}", // Fixed separator
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.warning), // Orange
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) =>
                                EditBook(book: book, onRefresh: _fetchBooks),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.danger), // Red
                          onPressed: () => _deleteBook(book['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent, // Use Accent (Blue)
        child: const Icon(Icons.add, color: AppColors.textOnDark),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => CreateBook(onRefresh: _fetchBooks),
        ),
      ),
    );
  }
}