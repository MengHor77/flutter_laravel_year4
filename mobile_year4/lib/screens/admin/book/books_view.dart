import 'dart:convert';
import 'edit_book.dart';
import 'create_book.dart';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../models/book_model.dart';
import '../../../providers/sale_provider.dart';

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

  /// FIXED HELPER: Cleans inconsistent image paths from the DB.
  /// Handles both "uploads/books/..." and "http://10.1.42.124:8000/..."
  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/150';
    }

    // If the path is already a full URL, use it directly
    if (path.startsWith('http')) {
      return path;
    }

    // Ensure there isn't a double slash when joining with the base URL
    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return "${ApiConfig.baseUrl}/$cleanPath";
  }

  Future<void> _fetchBooks() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(ApiConfig.books));
      if (response.statusCode == 200) {
        final List rawData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _books = rawData.map((json) => Book.fromJson(json)).toList();
          });
        }
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
          // Notify provider to update other parts of the app
          Provider.of<SaleProvider>(context, listen: false).refreshAll();

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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh List",
            onPressed: _fetchBooks,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "Add New Book",
            onPressed: () => showDialog(
              context: context,
              builder: (context) => CreateBook(onRefresh: _fetchBooks),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : _books.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _fetchBooks,
              color: AppColors.accent,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return _buildBookCard(book);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("No books found", style: TextStyle(fontSize: 16)),
          TextButton(
            onPressed: _fetchBooks,
            child: const Text("Try Fetching Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      color: AppColors.cardBg,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 50,
            height: 70,
            color: Colors.grey[200],
            child: Image.network(
              _getImageUrl(book.image),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
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
        subtitle: _buildPriceSection(book),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.warning),
              onPressed: () => showDialog(
                context: context,
                builder: (context) =>
                    EditBook(book: book, onRefresh: _fetchBooks),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.danger),
              onPressed: () => _confirmDelete(book),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.author,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        if (book.isOnSale)
          Row(
            children: [
              Text(
                "\$${book.price}",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "\$${book.displayPrice}",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        else
          Text(
            "\$${book.price}",
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  void _confirmDelete(Book book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '${book.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteBook(book.id);
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
