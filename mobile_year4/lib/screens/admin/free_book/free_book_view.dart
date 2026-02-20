import 'search_bookPDF.dart';
import '../../../colors.dart';
import 'edit_free_book_view.dart';
import '../../../api_config.dart';
import 'creat_free_book_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/free_book_pdf_provider.dart';

class FreeBookView extends StatefulWidget {
  final VoidCallback openDrawer;
  const FreeBookView({super.key, required this.openDrawer});

  @override
  State<FreeBookView> createState() => _FreeBookViewState();
}

class _FreeBookViewState extends State<FreeBookView> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FreeBookPdfProvider>(context, listen: false).fetchFreeBooks();
    });
  }

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return 'https://via.placeholder.com/150';
    if (path.startsWith('http')) {
      return path.replaceAll('127.0.0.1', '10.0.2.2');
    }
    return "${ApiConfig.storage}${path.startsWith('/') ? path.substring(1) : path}";
  }

   Future<void> _handleDelete(String id, String bookName) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Delete Book"),
            content: Text("Are you sure you want to delete '$bookName'?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      final success = await Provider.of<FreeBookPdfProvider>(
        context,
        listen: false,
      ).deleteFreeBook(id);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PDF deleted successfully"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Free Book PDF"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: "Search PDFs",
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookPDFSearchDelegate(
                  getImageUrl: _getImageUrl,
                  onDelete: (id) {
                    // We find the book name for the search delete dialog
                    final book = Provider.of<FreeBookPdfProvider>(
                      context,
                      listen: false,
                    ).freeBooks.firstWhere((b) => b.id == id);
                    _handleDelete(id, book.name);
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh List",
            onPressed: () => Provider.of<FreeBookPdfProvider>(
              context,
              listen: false,
            ).fetchFreeBooks(),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "Add Book",
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const CreateFreeBookView(),
            ),
          ),
        ],
      ),
      body: Consumer<FreeBookPdfProvider>(
        builder: (context, provider, child) {
          if (provider.isSyncing && provider.freeBooks.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          if (provider.freeBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No free books found."),
                  TextButton(
                    onPressed: _refreshData,
                    child: const Text("Try Refreshing Again"),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => provider.fetchFreeBooks(),
            color: AppColors.accent,
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: provider.freeBooks.length,
              itemBuilder: (context, index) {
                final book = provider.freeBooks[index];
                final String imageUrl = _getImageUrl(book.image);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        imageUrl,
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 50,
                          height: 70,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      book.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Author: ${book.author}"),
                        Text(
                          "Category: ${book.categoryName}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => EditFreeBookView(book: book),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _handleDelete(book.id, book.name),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
