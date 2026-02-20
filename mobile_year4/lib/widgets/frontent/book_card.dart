import '../../colors.dart';
import '../../api_config.dart';
import '../../models/book_model.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onAction;
  final String buttonText;
  final Color buttonColor;

  const BookCard({
    super.key,
    required this.book,
    required this.onAction,
    required this.buttonText,
    required this.buttonColor,
  });

  // Helper function to handle the URL logic
  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/150';
    }

    // If the database path already starts with http, return it as is
    if (path.startsWith('http')) {
      return path;
    }

    // Otherwise, clean the path and append the storage base URL
    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return "${ApiConfig.storage}$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    //  Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //  Use dynamic card background
      color: AppColors.getCardBg(isDark),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // 1. IMAGE SECTION WITH SALE BADGE
        leading: Stack(
          children: [
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                // Use dynamic background for image container
                color: AppColors.getBackground(isDark),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _getImageUrl(book.image),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      // Dark-mode friendly placeholder color
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      child: Icon(
                        Icons.book,
                        size: 40,
                        color: isDark ? Colors.grey[600] : Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),
            ),
            if (book.isOnSale)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    // Use dynamic danger color
                    color: AppColors.getDanger(isDark),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "SALE",
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
        title: Text(
          book.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // Use dynamic primary text color
            color: AppColors.getTextPrimary(isDark),
          ),
        ),
        // 2. DYNAMIC PRICE LOGIC IN SUBTITLE
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "By ${book.author}",
              style: TextStyle(
                //  Use dynamic secondary text color
                color: AppColors.getTextSecondary(isDark),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            if (book.isOnSale)
              Row(
                children: [
                  // Special Offer Price (Display Price)
                  Text(
                    "\$${book.displayPrice}",
                    style: TextStyle(
                      //  Use dynamic success color
                      color: AppColors.getSuccess(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Original Price (Strikethrough)
                  Text(
                    "\$${book.price}",
                    style: TextStyle(
                      //  Use dynamic danger color for strikethrough
                      color: AppColors.getDanger(isDark).withOpacity(0.8),
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              )
            else
              // Regular Price
              Text(
                "\$${book.price}",
                style: TextStyle(
                  //  Use dynamic success color
                  color: AppColors.getSuccess(isDark),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        // 3. ACTION BUTTON
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: AppColors.textOnDark,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onAction,
          child: Text(buttonText),
        ),
      ),
    );
  }
}
