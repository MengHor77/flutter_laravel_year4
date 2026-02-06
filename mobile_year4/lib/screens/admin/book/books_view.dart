import 'dart:convert';
import 'edit_book.dart';
import 'create_book.dart';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/book_model.dart';

class ManageBooksView extends StatefulWidget {
  final VoidCallback openDrawer;
  const ManageBooksView({super.key, required this.openDrawer});

  @override
  State<ManageBooksView> createState() => _ManageBooksViewState();
}

class _ManageBooksViewState extends State<ManageBooksView> {
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
        final List rawData = jsonDecode(response.body);
        setState(() {
          _books = rawData.map((json) => Book.fromJson(json)).toList();
        });
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteBook(String id) async {
    try {
      final response = await http.delete(Uri.parse("${ApiConfig.books}/$id"));
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Book deleted successfully!"),
              backgroundColor: AppColors.danger,
            ),
          );
        }
        _fetchBooks();
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Manage Books"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : _books.isEmpty
              ? const Center(child: Text("No books found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Card(
                      color: AppColors.cardBg,
                      elevation: 2,
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(book.image ?? 'https://via.placeholder.com/150'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          book.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "${book.author} | \$${book.price}",
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.warning),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => EditBook(book: book, onRefresh: _fetchBooks),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.danger),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Confirm Delete"),
                                    content: const Text("Are you sure?"),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("No")),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          _deleteBook(book.id);
                                        },
                                        child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: AppColors.textOnDark),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => CreateBook(onRefresh: _fetchBooks),
        ),
      ),
    );
  }
}