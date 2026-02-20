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
    if (path.startsWith('http')) {
      return path;
    }
    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return "${ApiConfig.storage}$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    // Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      // Elevation: 0 in dark mode prevents the "gray glow" effect
      elevation: isDark ? 0 : 2, 
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Add a subtle border in dark mode to define the card edges
        side: BorderSide(
          color: AppColors.getBorder(isDark),
          width: isDark ? 1 : 0,
        ),
      ),
      // Dynamic card background
      color: AppColors.getCardBg(isDark),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // 1. IMAGE SECTION
        leading: Stack(
          children: [
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : AppColors.getBackground(false),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _getImageUrl(book.image),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      child: Icon(
                        Icons.book,
                        color: isDark ? Colors.white38 : Colors.grey,
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
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
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
        // 2. TEXT SECTION
        title: Text(
          book.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(isDark),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "By ${book.author}",
              style: TextStyle(
                color: AppColors.getTextSecondary(isDark),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            if (book.isOnSale)
              Row(
                children: [
                  Text(
                    "\$${book.displayPrice}",
                    style: TextStyle(
                      color: AppColors.getSuccess(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "\$${book.price}",
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              )
            else
              Text(
                book.price == "0" || book.displayPrice == "FREE" 
                    ? "FREE" 
                    : "\$${book.price}",
                style: TextStyle(
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
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onAction,
          child: Text(
            buttonText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}