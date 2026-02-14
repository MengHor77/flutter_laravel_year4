import 'search_book.dart';
import '../../../colors.dart';
import 'save_book_to_file.dart'; 
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/free_book_pdf_provider.dart';
import 'package:mobile_year4/widgets/frontent/menu_sidebar.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book PDF Free'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        actions: [
          // Search Button integrated into AppBar
          Consumer<FreeBookPdfProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: BookSearchDelegate(provider.freeBooks),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: const AppSidebar(currentRoute: 'Book PDF Free'),
      body: Consumer<FreeBookPdfProvider>(
        builder: (context, provider, child) {
          if (provider.isSyncing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.freeBooks.isEmpty) {
            return const Center(child: Text("No free books available."));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchFreeBooks(),
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: provider.freeBooks.length,
              itemBuilder: (context, index) {
                final book = provider.freeBooks[index];
                
                // Keep your logic: check if URL is already full or needs prefix
                final imageUrl = book.image.startsWith('http') 
                    ? book.image 
                    : "${ApiConfig.baseUrl}/storage/${book.image}";
                
                final pdfUrl = book.pdfFile.startsWith('http') 
                    ? book.pdfFile 
                    : "${ApiConfig.baseUrl}/storage/${book.pdfFile}";

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book Cover Image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.book, size: 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              book.author,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Read Button
                                IconButton(
                                  icon: const Icon(
                                    Icons.menu_book,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _showSnackBar("Opening PDF: ${book.name}");
                                  },
                                ),
                                // Download Button
                                IconButton(
                                  icon: const Icon(
                                    Icons.download_for_offline,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    // FIXED: Now calls your BookSaver logic
                                    BookSaver.saveAndNotify(
                                      pdfUrl, 
                                      "${book.name}.pdf", 
                                      context
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
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}