import '../../models/book_model.dart';
import 'package:flutter/material.dart';
import '../../colors.dart'; // Import AppColors for consistency

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
        // Placeholder for Book Image using an Icon
        leading: Container(
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
        // FIXED: Changed book.title to book.name
        title: Text(
          book.name, 
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        // FIXED: Using book.author and book.price
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "By ${book.author}",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              "\$${book.price}",
              style: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: AppColors.textOnDark,
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