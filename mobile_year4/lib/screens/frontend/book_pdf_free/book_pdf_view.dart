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
      Uri currentUri = Uri.parse(ApiConfig.baseUrl);
      String currentHost = currentUri.host;
      return urlPath
          .replaceAll('127.0.0.1', currentHost)
          .replaceAll('localhost', currentHost)
          .replaceAll('192.168.1.105', currentHost)
          .replaceAll('192.168.1.104', currentHost);
    }

    String cleanPath = urlPath.startsWith('/') ? urlPath.substring(1) : urlPath;
    return cleanPath.startsWith('storage/')
        ? "${ApiConfig.baseUrl}/$cleanPath"
        : "${ApiConfig.baseUrl}/storage/$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    // Detect dark mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<FreeBookPdfProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // Use dynamic background
          backgroundColor: AppColors.getBackground(isDark),
          body: _buildContent(provider, isDark),
        );
      },
    );
  }

  Widget _buildContent(FreeBookPdfProvider provider, bool isDark) {
    if (provider.isSyncing) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (provider.freeBooks.isEmpty) {
      return Center(
        child: Text(
          "No free books available.",
          style: TextStyle(color: AppColors.getTextSecondary(isDark)),
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
            // Use dynamic card background
            color: AppColors.getCardBg(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // Optional subtle border for dark mode depth
              side: isDark
                  ? BorderSide(color: AppColors.getBorder(isDark), width: 0.5)
                  : BorderSide.none,
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
                          errorBuilder: (c, e, s) => Icon(
                            Icons.book,
                            size: 40,
                            color: AppColors.getTextSecondary(isDark),
                          ),
                        ),
                        _buildBadge(isDark),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(isDark),
                        ),
                      ),
                      Text(
                        book.author,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.getTextSecondary(isDark),
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
                            backgroundColor: AppColors.getSuccess(isDark),
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

  Widget _buildBadge(bool isDark) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          // Using success color for consistency
          color: AppColors.getSuccess(isDark).withValues(alpha: 0.9),
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
