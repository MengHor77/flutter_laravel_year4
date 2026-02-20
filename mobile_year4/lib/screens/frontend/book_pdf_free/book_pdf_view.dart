import 'download_book.dart';
import '../../../colors.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FreeBookPdfProvider>(context, listen: false).fetchFreeBooks();
    });
  }

  String _formatUrl(String? urlPath) {
    if (urlPath == null || urlPath.isEmpty) {
      return 'https://via.placeholder.com/150';
    }

    if (urlPath.startsWith('http')) {
      return urlPath
          .replaceAll('127.0.0.1', '10.0.2.2')
          .replaceAll('192.168.1.105', '192.168.1.104');
    }

    String cleanPath = urlPath.startsWith('/') ? urlPath.substring(1) : urlPath;
    return cleanPath.startsWith('storage/')
        ? "${ApiConfig.baseUrl}/$cleanPath"
        : "${ApiConfig.baseUrl}/storage/$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FreeBookPdfProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          // Search button removed here because MainLayout handles it
          body: _buildContent(provider),
        );
      },
    );
  }

  Widget _buildContent(FreeBookPdfProvider provider) {
    if (provider.isSyncing) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
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
          childAspectRatio: 0.62,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: provider.freeBooks.length,
        itemBuilder: (context, index) {
          final book = provider.freeBooks[index];
          final imageUrl = _formatUrl(book.image);
          final pdfUrl = _formatUrl(book.pdfFile);

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) =>
                              const Icon(Icons.book, size: 40),
                        ),
                        _buildBadge(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        book.author,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => BookSaver.saveAndNotify(
                            pdfUrl,
                            "${book.name}.pdf",
                            context,
                          ),
                          icon: const Icon(
                            Icons.file_download_outlined,
                            size: 18,
                          ),
                          label: const Text("Download"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
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
  }

  Widget _buildBadge() {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha:0.9),
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
    );
  }
}
