import '../../../colors.dart';
import 'edit_free_book_view.dart';
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

  void _handleDelete(String id) async {
    final success = await Provider.of<FreeBookPdfProvider>(
      context,
      listen: false,
    ).deleteFreeBook(id);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("PDF deleted successfully"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Manage Free PDFs"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
        actions: [
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
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 40,
                    ),
                    title: Text(
                      book.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(book.author),
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
                          onPressed: () {
                            // Simple Confirmation
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete Book"),
                                content: const Text("Are you sure?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      _handleDelete(book.id);
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
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
          );
        },
      ),
    );
  }
}
