import '../../colors.dart'; 
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.cardBg,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // 1. IMAGE SECTION WITH SALE BADGE
        leading: Stack(
          children: [
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.book, 
                size: 40, 
                color: AppColors.accent,
              ),
            ),
            if (book.isOnSale)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    borderRadius:  BorderRadius.only(
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        // 2. DYNAMIC PRICE LOGIC IN SUBTITLE
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "By ${book.author}",
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 6),
            if (book.isOnSale)
              Row(
                children: [
                  // Special Offer Price (Display Price)
                  Text(
                    "\$${book.displayPrice}",
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Original Price (Strikethrough)
                  Text(
                    "\$${book.price}",
                    style: const TextStyle(
                      color: AppColors.danger,
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
                style: const TextStyle(
                  color: AppColors.success,
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