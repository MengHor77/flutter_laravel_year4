import 'search_book.dart';
import '../../../colors.dart';
import 'save_book_to_file.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/free_book_pdf_provider.dart';

class BookPdfView extends StatefulWidget {
  const BookPdfView({super.key});

  @override
  State<BookPdfView> createState() => _BookPdfViewState();
}

class _BookPdfViewState extends State<BookPdfView> {
  @override
  void initState() {
    super.initState();
    // Fetch books when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FreeBookPdfProvider>(context, listen: false).fetchFreeBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ❌ REMOVED Scaffold, AppBar, and Sidebar because MainWrapper provides them
    return Consumer<FreeBookPdfProvider>(
      builder: (context, provider, child) {
        if (provider.isSyncing) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.freeBooks.isEmpty) {
          return const Center(
            child: Text(
              "No free books available.",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchFreeBooks(),
          color: AppColors.accent,
          child: GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65, // Adjusted for better card fit
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.freeBooks.length,
            itemBuilder: (context, index) {
              final book = provider.freeBooks[index];

              // Handle Image and PDF URLs
              final imageUrl = book.image.startsWith('http')
                  ? book.image
                  : "${ApiConfig.baseUrl}/storage/${book.image}";

              final pdfUrl = book.pdfFile.startsWith('http')
                  ? book.pdfFile
                  : "${ApiConfig.baseUrl}/storage/${book.pdfFile}";

              return Card(
                elevation: 4,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Book Cover ---
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.book,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                            // Optional "FREE" badge
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  "FREE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Book Details ---
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            book.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Read Icon
                              _buildActionButton(
                                icon: Icons.menu_book_rounded,
                                color: Colors.blue,
                                tooltip: "Read",
                                onTap: () =>
                                    _showSnackBar("Opening PDF: ${book.name}"),
                              ),
                              // Download Icon
                              _buildActionButton(
                                icon: Icons.download_for_offline_rounded,
                                color: Colors.green,
                                tooltip: "Download",
                                onTap: () {
                                  BookSaver.saveAndNotify(
                                    pdfUrl,
                                    "${book.name}.pdf",
                                    context,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Action Button Helper
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
